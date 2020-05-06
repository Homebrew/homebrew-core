class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.34.0.tar.gz"
    sha256 "973293ffbcfa4fb073f6a2f833b0ce5b82b72f7899427f39d7e5610ffc9029c8"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.10.0.tar.gz"
      sha256 "3aea420df959552d1866d473c878ab1ed0b58489c4c9881ef40a170cfb775459"
    end
  end

  bottle do
    sha256 "7f6f09fefecbeab7ff11bcd35b501339f99aa2b4409c8612e1eae2c4ad0a206c" => :catalina
    sha256 "a2a5055a9abe2db444e2a165133703a1c203d692f66c0e1fb326c97a28c8ef80" => :mojave
    sha256 "c37811acb4753d689d8d7455b0ddfd64bf9530c430240563608e05b6bed8cedd" => :high_sierra
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "autoconf"      => :build # for building bdw-gc
  depends_on "automake"      => :build # for building bdw-gc
  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "libtool"       => :build # for building bdw-gc

  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@1.1" # std uses it but it's not linked
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  # Crystal uses an extended version of bdw-gc to handle multi-threading
  resource "bdw-gc" do
    url "https://github.com/ivmai/bdwgc/releases/download/v8.0.4/gc-8.0.4.tar.gz"
    sha256 "436a0ddc67b1ac0b0405b61a9675bca9e075c8156f4debd1d06f3a56c7cd289d"

    # extension to handle multi-threading
    patch :p1 do
      url "https://github.com/ivmai/bdwgc/commit/5668de71107022a316ee967162bc16c10754b9ce.patch?full_index=1"
      sha256 "5c42d4b37cf4997bb6af3f9b00f5513644e1287c322607dc980a1955a09246e3"
    end
  end

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.33.0/crystal-0.33.0-1-darwin-x86_64.tar.gz"
    version "0.33.0-1"
    sha256 "edb48d4d8276fc5e689fb95c5dc669d115ad3d1bf22485dad77d44a370e585fd"
  end

  def install
    (buildpath/"boot").install resource("boot")

    ENV["CRYSTAL_CONFIG_BUILD_COMMIT"] = Utils.popen_read("git rev-parse --short HEAD").strip if build.head?

    ENV["CRYSTAL_CONFIG_PATH"] = "lib:#{prefix/"src"}"
    ENV["CRYSTAL_CONFIG_LIBRARY_PATH"] = prefix/"embedded/lib"
    ENV.append_path "PATH", "boot/bin"

    resource("bdw-gc").stage(buildpath/"gc")
    cd(buildpath/"gc") do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-shared",
                            "--enable-large-config"
      system "make"
    end

    ENV.prepend_path "CRYSTAL_LIBRARY_PATH", buildpath/"gc/.libs"

    # Build crystal
    (buildpath/".build").mkpath
    system "make", "deps"
    system "bin/crystal", "build",
                          "-D", "without_openssl",
                          "-D", "without_zlib",
                          "-D", "preview_overflow",
                          "-o", ".build/crystal",
                          "src/compiler/crystal.cr",
                          "--release", "--no-debug"

    # Build shards
    resource("shards").stage do
      system buildpath/"boot/embedded/bin/shards", "install",
                                                   "--production"

      system buildpath/"bin/crystal", "build",
                                      "-o", buildpath/".build/shards",
                                      "src/shards.cr",
                                      "--release", "--no-debug"

      man1.install "man/shards.1"
      man5.install "man/shard.yml.5"
    end

    bin.install ".build/shards"
    libexec.install ".build/crystal"
    (bin/"crystal").write_env_script libexec/"crystal",
      :PKG_CONFIG_PATH => "${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}#{Formula["openssl@1.1"].opt_lib/"pkgconfig"}"

    prefix.install "src"
    (prefix/"embedded/lib").install "#{buildpath/"gc"}/.libs/libgc.a"

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end

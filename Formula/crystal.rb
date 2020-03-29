class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.33.0.tar.gz"
    sha256 "88f08685f172e98f01f93f1a83fc3548c6d28df19a39c91859b167a796730289"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    sha256 "3ee8d5d0e6c6e96e0f54b4a7e0d5795e3c450a346ac208b0b6f1208e34bf1567" => :catalina
    sha256 "8102e213251723389bab813719ec7a7a54abb5730983ae7d2b47d6f2cfed1463" => :mojave
    sha256 "1acff2894744122bebae34438a3a32fd0fe79be82e024b62e1cfdda995e96c6a" => :high_sierra
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.32.1/crystal-0.32.1-1-darwin-x86_64.tar.gz"
    version "0.32.1-1"
    sha256 "2901e8709da36a12ce0a94464741c1db8e5b5080f216fb8c1f7016667370bc94"
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
      :PKG_CONFIG_PATH => "${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}#{Formula["openssl"].opt_lib/"pkgconfig"}"

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

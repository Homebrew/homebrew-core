class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.32.1.tar.gz"
    sha256 "66b62d0fb5bfa6547f285eb520f7fd0bc57bc994babf54cb8e7a61e613c79399"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    sha256 "ca6dc355fb0e07011cfd10e796017284b2983dd60484cc68815eb7b50b9b994f" => :catalina
    sha256 "41abc191c23487d1b937aef1d8be92214ce302dc34e7b13700fe0317950f09bf" => :mojave
    sha256 "87c7e1b222f6e363ed1451ab0fcf9955a3f7bd86126c31b40e0d5ca74064309c" => :high_sierra
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.31.1/crystal-0.31.1-1-darwin-x86_64.tar.gz"
    version "0.31.1-1"
    sha256 "ffc655df0efe8004058f87750949b7a2b165d8baef73c5596193eba1c17efdb5"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_BUILD_COMMIT"] = Utils.popen_read("git rev-parse --short HEAD").strip
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:lib"
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

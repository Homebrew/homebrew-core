class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.31.1.tar.gz"
    sha256 "b4a51164763b891572492e2445d3a69b462675184ea0ccf06fcc57a070f07b80"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    sha256 "a1fe1a4600c29faca4b8e4fa1016e1daa6667129b5956ff9d5777efe4da629b2" => :mojave
    sha256 "e6af5b650eb9b5200e503989cee515f2da25b7778c651259288c8c62520aeb6c" => :high_sierra
    sha256 "beff786db2fef34041bcc562909067fe667c315a57c30c5fc708ca80a838c0ba" => :sierra
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@8"
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.30.1/crystal-0.30.1-1-darwin-x86_64.tar.gz"
    version "0.30.1-1"
    sha256 "ffc3ee9124367a2dcd76f9b4c2bf8df083ba8fce506aaf0e3c6bfad738257adc"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_BUILD_COMMIT"] = Utils.popen_read("git rev-parse --short HEAD").strip
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:lib"
    ENV.append_path "PATH", "boot/bin"

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
    bin.install ".build/crystal"
    prefix.install "src"

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end

class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.18.2.tar.gz"
  sha256 "59f09e4132b3ebced24cfc9123d5629f87f79901241aec704c7a89f2a6fab4ab"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "db101d6621f0f01561ed7b6db8f5fad2e462eec6e6130c205361bbc00fe25903" => :el_capitan
    sha256 "502e81813ddf86cb093c63d1f91f356f6a7d4a10dd7a3de8f156737f44fe04d2" => :yosemite
    sha256 "f1e68035996dba9387c9430f58b97e31a3bbf37810e8cbd4ae4300c34c5865e6" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.18.0/crystal-0.18.0-1-darwin-x86_64.tar.gz"
    version "0.18.0"
    sha256 "103da1ff33f0f80e01f374eab0cb2a8c1ecb472a6c287e9f54fd0d97a98e8258"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.3.tar.gz"
    sha256 "5245aebb21af0a5682123732e4f4d476e7aa6910252fb3ffe4be60ee8df03ac2"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = `git rev-parse --short HEAD`.strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:libs"
    ENV.append_path "PATH", "boot/bin"

    if build.with? "release"
      system "make", "crystal", "release=true"
    else
      system "make", "deps"
      (buildpath/".build").mkpath
      system "bin/crystal", "build", "-o", "-D", "without_openssl", "-D", "without_zlib", ".build/crystal", "src/compiler/crystal.cr"
    end

    if build.with? "shards"
      resource("shards").stage do
        system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
      end
      bin.install ".build/shards"
    end

    bin.install ".build/crystal"
    prefix.install "src"
    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "crystal"
  end

  test do
    system "#{bin}/crystal", "eval", "puts 1"
  end
end

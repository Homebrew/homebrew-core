class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.18.0.tar.gz"
  sha256 "e0511268558f0400f72b970db049a453212ca94d9ba3250912bfffa3abcb69e4"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "cf116acc0b2f2028e2a848e3405b603c0989d4ea51086e3a8c9d728d3881363e" => :el_capitan
    sha256 "5e66e475695d0336f12a813cb633e23e4bdc2051ebfe562a53b4f9af13651b49" => :yosemite
    sha256 "eb8fbbac4c8af7a46a946a615c3248d13692e319a6829d9765988df44c62a7ff" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.17.4/crystal-0.17.4-1-darwin-x86_64.tar.gz"
    version "0.17.4"
    sha256 "d469967cef1f5136349589a3fccb3ea5fde9765ba60aa5eee8724049315a9606"
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

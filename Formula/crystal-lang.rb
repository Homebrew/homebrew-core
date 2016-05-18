class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.17.1.tar.gz"
  sha256 "6ba169c3b61d983c2fe43be21f054f1ca82d46d32e0a5d29bc39778d0d625ffc"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "5852ffcfb2ebd4f95c95b41e46b204eb45fd6601a955ec11d90893876ffa1539" => :el_capitan
    sha256 "068cf05efc6369f777371b7292d9a93a74983e1fa2918dc2103d7487f32e8751" => :yosemite
    sha256 "54efd3723c8cd6ccbee51dc01fc08bb45802da86cf06a40e54c9f0ae12d7b089" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.16.0/crystal-0.16.0-1-darwin-x86_64.tar.gz"
    version "0.16.0"
    sha256 "a41e55b7beecd22a681f53ce5fa4fe7c8cd193ebb87508b1cbd4e211c3e5409e"
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

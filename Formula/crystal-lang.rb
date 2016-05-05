class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.16.0.tar.gz"
  sha256 "6bc77686da5cb7d1bf34397d6e57381d301a74d97420d1fb5ea7f13c4e8e1dc8"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "ad7c29c8fb31a01bf7c84d53188897afeaefdd6dc8d6d14490d15f6f9ea37af4" => :el_capitan
    sha256 "4009fdf987166c815428738a1fd2e6d784846899a9d36685f3380f19f00b6b8f" => :yosemite
    sha256 "51f05828adedb594550f42ee1f4c3e3352aa9c110249786ed0c69acce247e2ad" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.15.0/crystal-0.15.0-1-darwin-x86_64.tar.gz"
    version "0.15.0"
    sha256 "97b35279d4e6e0248e7824753711f3e40c442cba0c94a5b9ea52dc7ab156b668"
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

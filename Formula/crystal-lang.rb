class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.19.2.tar.gz"
  sha256 "18b8b847162529b1ea6e886ad2fbe344a1bcb22fd8b29cebedc5a827939d3819"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "fd196273eed8c674aed24a65b5f0ddbc89fa7499ef3c53d825e6e563f6b18590" => :el_capitan
    sha256 "0c1578ce923b8ae9be325570e2bdb7be75dab113b6d7afae9521f6c7f8422e93" => :yosemite
    sha256 "d8083d7dfc40e2fa1f92f60856d5a737d8788d41d42694e3d623ac9a315ff555" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm"
  depends_on "pcre"
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.19.1/crystal-0.19.1-1-darwin-x86_64.tar.gz"
    version "0.19.1"
    sha256 "5ddd3fcfb576f960708b397c85e3e9c81a79f39cd77c73a4203d22f6303c53f9"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.4.tar.gz"
    sha256 "5972f1b40bb3253319f564dee513229f82b0dcb8eea1502ae7dc483a9c6da5a0"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = Utils.popen_read("git rev-parse --short HEAD").strip
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
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end

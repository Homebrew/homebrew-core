class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.19.3.tar.gz"
  sha256 "72954087131bd648735bc397cfd585204087a4b8ab7f927f0a054741381ea01f"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "bc56c6f55fb822566062a48f2ec4d781078fe42741aacce5f60f95cb3b3fd308" => :sierra
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.19.2/crystal-0.19.2-1-darwin-x86_64.tar.gz"
    version "0.19.2"
    sha256 "d5254e3e2d1e5fc851831a57573429876e5c9f86b2db066a2c74c392ae9080a2"
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

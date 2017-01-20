class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.20.5.tar.gz"
  sha256 "ee1e5948c6e662ccb1e62671cf2c91458775b559b23d74ab226dc2a2d23f7707"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "ec71a4e7fea963517452ddab11677961d7f142c704d4284da07cdd0fcb51cbcd" => :sierra
    sha256 "6a65d4fc969f1e7b7d97a615b7ce9228a061b6de6edf9141bfe03105abeaeb6e" => :el_capitan
    sha256 "fd77bcb80689e26b80e63490329fb7a3f7731414d793191cea2f20d6b96fd4bc" => :yosemite
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm"
  depends_on "pcre"
  depends_on "gmp"
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.20.4/crystal-0.20.4-1-darwin-x86_64.tar.gz"
    version "0.20.4"
    sha256 "3fd291a4a5c9eccdea933a9df25446c90d80660a17e89f83503fcb5b6deba03e"
  end

  resource "shards" do
    url "https://github.com/crystal-lang/shards/archive/v0.7.1.tar.gz"
    sha256 "31de819c66518479682ec781a39ef42c157a1a8e6e865544194534e2567cb110"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = Utils.popen_read("git rev-parse --short HEAD").strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:lib"
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

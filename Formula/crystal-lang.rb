class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.19.1.tar.gz"
  sha256 "7528fc1ec63a3e9db9aabbccccfc8985511d6a54e44c5a1b26ccd0ee37275937"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "b0786504035c528082aae5b05e5bebd477bd5c8b45718fe2132af28fc798996e" => :el_capitan
    sha256 "48dc339af7f02a2056521f969f4776f91f5ad5821e40f0d3646bdb59f25f6c4a" => :yosemite
    sha256 "8d08b9cc73c031103770d6f4712ef92660562896535ecd326d8eb5b2ddd5218f" => :mavericks
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.19.0/crystal-0.19.0-1-darwin-x86_64.tar.gz"
    version "0.19.0"
    sha256 "7c54d97d646fe8fcb0e54289aa0b55e45222fa10f384c5675e61ff6018292677"
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

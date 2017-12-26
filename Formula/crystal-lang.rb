class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  revision 4

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.23.1.tar.gz"
    sha256 "8cf1b9a4eab29fca2f779ea186ae18f7ce444ce189c621925fa1a0c61dd5ff55"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.7.1.tar.gz"
      sha256 "31de819c66518479682ec781a39ef42c157a1a8e6e865544194534e2567cb110"
    end
  end

  bottle do
    sha256 "91a0f66c1d2a9538699aff8366b13508299550abade47c8fa266d96836e0eb4c" => :high_sierra
    sha256 "613ee02629654a29249b7e720ad3205547cbdc8ee37c77354c75c7e472e492d1" => :sierra
    sha256 "3b8042840d831b6e13177e2ecbc5b700a9ac9591c6dc451ff01cc6b70c33b20a" => :el_capitan
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm@4"
  depends_on "pcre"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.23.0/crystal-0.23.0-1-darwin-x86_64.tar.gz"
    version "0.23.0"
    sha256 "5ffa252d2264ab55504a6325b7c42d0eb16065152d0adfee6be723fd02333fdf"
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
    zsh_completion.install "etc/completion.zsh" => "_crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end

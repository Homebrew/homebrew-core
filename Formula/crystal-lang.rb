class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.20.5.tar.gz"
  sha256 "ee1e5948c6e662ccb1e62671cf2c91458775b559b23d74ab226dc2a2d23f7707"
  revision 2
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    rebuild 2
    sha256 "c1ac5f44b784dedc6c4489723af6c3ba1827437148deae3a2190e7735c434b1e" => :sierra
    sha256 "c487674f973eca52a94485368b5b9edc6de0e67d8991a36e63b0ccb547567857" => :el_capitan
    sha256 "b065a9a128b3a889db8e8db01714e2f9ff386399fe28a8221ad9b903ed9c2134" => :yosemite
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build # for building bdw-gc
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

  resource "bdw-gc-7.6.0" do
    url "http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz"
    sha256 "a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90"
  end

  resource "libevent-2.0.22" do
    url "https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz"
    sha256 "71c2c49f0adadacfdbe6332a372c38cf9c8b7895bb73dabeaa53cdcc1d4e1fa3"
  end

  def install
    resource("bdw-gc-7.6.0").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{buildpath}/vendor/bdw-gc",
                            "--enable-cplusplus"
      system "make"
      system "make", "install"
    end

    resource("libevent-2.0.22").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-debug-mode",
                            "--prefix=#{buildpath}/vendor/libevent"
      ENV.deparallelize do
        system "make"
        system "make", "install"
      end
    end

    (buildpath/"boot").install resource("boot")

    macho = MachO.open("#{buildpath}/boot/embedded/bin/crystal")
    macho.change_dylib("/usr/local/opt/libevent/lib/libevent-2.0.5.dylib",
                       "#{buildpath}/vendor/libevent/lib/libevent-2.0.5.dylib")
    macho.change_dylib("/usr/local/opt/bdw-gc/lib/libgc.1.dylib",
                       "#{buildpath}/vendor/bdw-gc/lib/libgc.1.dylib")
    macho.write!

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

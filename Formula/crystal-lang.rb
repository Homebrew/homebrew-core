class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.21.0.tar.gz"
  sha256 "4dd01703f5304a0eda7f02fc362fba27ba069666097c0f921f8a3ee58808779c"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "96a6f1437a74ea6b51215c19691d7651657067408f19f225834dc7089b8594ce" => :sierra
    sha256 "7d031e78287be5ee86f62524de2455d34702eaa2868831f40af3bb42622ccca9" => :el_capitan
    sha256 "1c91f912538ddc5ec0d94d20992f7b96f063a3671a770665713e42af76c86865" => :yosemite
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.20.5/crystal-0.20.5-1-darwin-x86_64.tar.gz"
    version "0.20.5"
    sha256 "79462c8ff994b36cff219c356967844a17e8cb2817bb24a196a960a08b8c9e47"
  end

  resource "shards" do
    url "https://github.com/crystal-lang/shards/archive/v0.7.1.tar.gz"
    sha256 "31de819c66518479682ec781a39ef42c157a1a8e6e865544194534e2567cb110"
  end

  resource "bdw-gc-7.6.0" do
    url "https://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz"
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

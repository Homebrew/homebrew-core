class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.20.5.tar.gz"
  sha256 "ee1e5948c6e662ccb1e62671cf2c91458775b559b23d74ab226dc2a2d23f7707"
  head "https://github.com/crystal-lang/crystal.git"
  revision 2

  bottle do
    rebuild 1
    sha256 "0bb9e463f9bedc321d1f507c341f6bbbb59141bf47caf28bef4a61e1d6d6d711" => :sierra
    sha256 "c94f2f493daf688432cd1af07f4730994726fa1f6e6cb022caa3e01c11e29bd4" => :el_capitan
    sha256 "1581d0a871f6af23b3fa13923d9c85ff8e2db9cd80e1ed88a26c1f2f09cfe86c" => :yosemite
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
    zsh_completion.install "etc/completion.zsh" => "crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end

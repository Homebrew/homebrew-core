class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_monterey: "21246762701565862a0d235039d4b559df0dac2fb98e0ef0a3078c45129c3885"
    sha256                               arm64_big_sur:  "78f0c6c13640bf98795ac05bc02b228458482542a4a47520940f87b3944d9747"
    sha256                               monterey:       "09afe34cfcc3cac93538418b0e3b49051e3b081bb1696b087303a1ac36809120"
    sha256                               big_sur:        "d843864ee6b5ee46e0e29ea062898f11e3a49cc824c53e663313506daebb623f"
    sha256                               catalina:       "07e2f14d45e308cb31f58cd56a2bd3a772349893d098f4a94d85fe153d1153e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207e5227a9665c0a34afc484869f85415d878561a1f0fea70838bcc392dbe0c8"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  uses_from_macos "zlib"

  on_linux do
    depends_on "glibc@2.13" => :build
    depends_on "linux-headers@4.4" => :build
  end

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-deterministic-archives",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}",
      "--disable-werror",
      "--enable-interwork",
      "--enable-multilib",
      "--enable-64-bit-bfd",
      "--enable-plugins",
      "--enable-targets=all",
      "--with-system-zlib",
      "--disable-nls",
      "--disable-gold",
      "--disable-gprofng", # Fails to build on Linux
    ]
    system "./configure", *args
    # Pass MAKEINFO=true to disable generation of HTML documentation.
    # This avoids a build time dependency on texinfo.
    make_args = OS.mac? ? [] : ["MAKEINFO=true"]
    system "make", *make_args
    system "make", "install", *make_args

    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      # Reduce the size of the bottle.
      system "strip", *bin.children, *lib.glob("*.a")
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end

class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  revision 1

  bottle do
    sha256                               arm64_monterey: "a4e8c248c8ca839855bebec3e0a0414f6cbb2b6f25c4556af87691f0e5b5f19a"
    sha256                               arm64_big_sur:  "5c7e1a88496e77d129216c995c1a42bfc806c01677e830ee578125fd632eb57b"
    sha256                               monterey:       "8ae9223fa1f08d34e36d1d6444af57fc4264c97045d8095acb7ab7b5e6113bc2"
    sha256                               big_sur:        "2a2bf7d856f86ea3b01eab9d267167f85b3c90457336e58908d7d53135dacfc1"
    sha256                               catalina:       "840ebed8d7204e8392aff0f830baff3e6a749207d70cc7b44b2d29f4f1444eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a90a33ab3678b5a325d8f5f16470f17a04700717ae936d7d71a81c37354d605"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  uses_from_macos "zlib"

  on_linux do
    depends_on "glibc@2.13" => :build
  end

  def install
    # Fix error: 'LONG_MIN' undeclared
    ENV.append "CFLAGS", "-DHAVE_LIMITS_H -DHAVE_FCNTL_H" unless OS.mac?

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

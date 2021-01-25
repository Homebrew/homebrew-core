class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/pkg-config-0.29.2.tar.gz"
  sha256 "6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://pkg-config.freedesktop.org/releases/"
    regex(/href=.*?pkg-config[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0040b6ebe07f60549800b211343fd5fb3cf83c866d9f62e40f5fb2f38b71e161" => :big_sur
    sha256 "ffd4491f62201d14b7eca6beff954a2ab265351589cd5b3b79b8bbb414485574" => :arm64_big_sur
    sha256 "80f141e695f73bd058fd82e9f539dc67471666ff6800c5e280b5af7d3050f435" => :catalina
    sha256 "0d14b797dba0e0ab595c9afba8ab7ef9c901b60b4f806b36580ef95ebb370232" => :mojave
    sha256 "8c6160305abd948b8cf3e0d5c6bb0df192fa765bbb9535dda0b573cb60abbe52" => :high_sierra
  end

  pour_bottle? do
    # The pc_path is baked into the binary and relocatable detection doesn't pick it up
    reason "The bottle only works in the default #{Homebrew::DEFAULT_PREFIX} location."
    satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX }
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    on_macos do
      pc_path << "/usr/local/lib/pkgconfig"
      pc_path << "/usr/lib/pkgconfig"
      pc_path << "#{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}"
    end
    on_linux do
      pc_path << "#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"
    end
    pc_path = pc_path.uniq.join(File::PATH_SEPARATOR)

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path}",
                          "--with-system-include-path=#{MacOS.sdk_path_if_needed}/usr/include"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"foo.pc").write <<~EOS
      prefix=/usr
      exec_prefix=${prefix}
      includedir=${prefix}/include
      libdir=${exec_prefix}/lib

      Name: foo
      Description: The foo library
      Version: 1.0.0
      Cflags: -I${includedir}/foo
      Libs: -L${libdir} -lfoo
    EOS

    ENV["PKG_CONFIG_LIBDIR"] = testpath
    system bin/"pkg-config", "--validate", "foo"
    assert_equal "1.0.0\n", shell_output("#{bin}/pkg-config --modversion foo")
    assert_equal "-lfoo\n", shell_output("#{bin}/pkg-config --libs foo")
    assert_equal "-I/usr/include/foo\n", shell_output("#{bin}/pkg-config --cflags foo")
  end
end

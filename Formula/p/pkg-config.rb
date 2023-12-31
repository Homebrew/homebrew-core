class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/pkg-config-0.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/pkg-config-0.29.2.tar.gz"
  sha256 "6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://pkg-config.freedesktop.org/releases/"
    regex(/href=.*?pkg-config[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256                               arm64_sonoma:   "7b59abc0b5381065b1eab174217307af9324e0d02edf903171b29250ae58aeaf"
    sha256                               arm64_ventura:  "3ff612c5e44b945c8c0cc6df7d3edb407ca67cddad9c89f9ab99ced494b7a8c2"
    sha256                               arm64_monterey: "2af9bceb60b70a259f236f1d46d2bb24c4d0a4af8cd63d974dde4d76313711e0"
    sha256                               arm64_big_sur:  "ffd4491f62201d14b7eca6beff954a2ab265351589cd5b3b79b8bbb414485574"
    sha256                               sonoma:         "421571f340277c62c5cc6fd68737bd7c4e085de113452ea49b33bcd46509bb12"
    sha256                               ventura:        "c44b1544815518726d280d92d6f6df09bd45e41ad20fd43424725c1c20760be8"
    sha256                               monterey:       "a6ba80711f98b65d8a2bf2c9278540860415e9b5e545da338a4d94f39d119285"
    sha256                               big_sur:        "0040b6ebe07f60549800b211343fd5fb3cf83c866d9f62e40f5fb2f38b71e161"
    sha256                               catalina:       "80f141e695f73bd058fd82e9f539dc67471666ff6800c5e280b5af7d3050f435"
    sha256                               mojave:         "0d14b797dba0e0ab595c9afba8ab7ef9c901b60b4f806b36580ef95ebb370232"
    sha256                               high_sierra:    "8c6160305abd948b8cf3e0d5c6bb0df192fa765bbb9535dda0b573cb60abbe52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9b8bf9b7b4bd08086be1104e3e18afb1c437dfaca03e6e7df8f2710b9c1c1a"
  end

  conflicts_with "pkgconf", because: "both install `pkg.m4` file"

  # FIXME: The bottle is mistakenly considered relocatable on Linux.
  # See https://github.com/Homebrew/homebrew-core/pull/85032.
  pour_bottle? only_if: :default_prefix

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    pc_path << if OS.mac?
      system_include_path = "#{MacOS.sdk_path_if_needed}/usr/include"

      pc_path << "/usr/local/lib/pkgconfig"
      pc_path << "/usr/lib/pkgconfig"
      "#{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}"
    else
      system_include_path = "/usr/include"

      "#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"
    end

    pc_path = pc_path.uniq.join(File::PATH_SEPARATOR)

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path}",
                          "--with-system-include-path=#{system_include_path}"
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

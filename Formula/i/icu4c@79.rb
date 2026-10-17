class Icu4cAT79 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-79.1rc/icu4c-79.1rc-sources.tgz"
  sha256 "9d9891c0e753801d4fb640d1bfd2310b318d267bd47b8e7461e39d547bbb3146"
  license "Unicode-3.0"
  compatibility_version 1

  # We allow the livecheck to detect new `icu4c` major versions in order to
  # automate version bumps. To make sure PRs are created correctly, we output
  # an error during installation to notify when a new formula is needed.
  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  keg_only :shadowed_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  deny_network_access!

  def install
    odie "Major version bumps need a new formula!" if version.major.to_s != name[/@(\d+)$/, 1]

    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end

    inreplace [bin/"icu-config", *lib.glob("pkgconfig/icu-*.pc")], prefix, opt_prefix
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system bin/"gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system bin/"gendict", "--uchars", "hello", "dict"
    end
  end
end

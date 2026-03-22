class Icu4cAT78 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-78.3/icu4c-78.3-sources.tgz"
  sha256 "3a2e7a47604ba702f345878308e6fefeca612ee895cf4a5f222e7955fabfe0c0"
  license "ICU"
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

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0476be299494b97e50a48b0ba08811255300228aef664058e555480d6aee4fb5"
    sha256 cellar: :any,                 arm64_sequoia: "d1206febbce23e5014f51b631afd7129b2a247ee18a9f97226cd5889e66c1686"
    sha256 cellar: :any,                 arm64_sonoma:  "e15b43778ccf194d2ebef8122ff654899825df30aa339ad39578c66500eaa6d8"
    sha256 cellar: :any,                 sonoma:        "100ba33fb4652a045e921b19e0e52a8c7aa20a3e90adcdeaae58e53d4a43d39a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76dae2c62a79c94411f88eb7c8c702429d15ad8d5d6df17bfa855539df3497a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b152f4b6f581af753a52bf6dc5b7a113cd9f77088dcc94deaf6c321109aa43c2"
  end

  keg_only :shadowed_by_macos, "macOS provides libicucore.dylib (but nothing else)"

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

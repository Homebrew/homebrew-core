class Libiptcdata < Formula
  desc "Virtual package provided by libiptcdata0"
  homepage "https://libiptcdata.sourceforge.net/"
  url "https://github.com/ianw/libiptcdata/releases/download/release_1_0_5/libiptcdata-1.0.5.tar.gz"
  sha256 "c094d0df4595520f194f6f47b13c7652b7ecd67284ac27ab5f219bc3985ea29e"
  license "LGPL-2.0-only"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "56f886ae4863583e9c8d911dd0f312b1ddb7330043e3296eb5cdeeb14cdf13f2"
    sha256 arm64_sequoia: "b05cc07d640693e52679619487e236f3685a1d35ad1af434d44f231a1d26601f"
    sha256 arm64_sonoma:  "4768dd0ed241d95b8b309564e91ef6dcaeeadc6d5f3a177822f693dd668ee0c2"
    sha256 sonoma:        "3f94564c26a2283a245b5593d1e9082440932730071ae8527ba51f927b1997c5"
    sha256 arm64_linux:   "b9007e8fd2a48d129709d296367e69eaa4c6d5b20a3682590f91fe5110c153e8"
    sha256 x86_64_linux:  "5118f85e9d7a8cdc95465502824841fa6dc745d481dabc5f5d09686ba8872534"
  end

  on_macos do
    depends_on "gettext"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iptc --version")
    assert_match "ModelVersion", shell_output("#{bin}/iptc --list")
  end
end

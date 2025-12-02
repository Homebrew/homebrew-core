class Aalib < Formula
  desc "Portable ASCII art graphics library"
  homepage "https://aa-project.sourceforge.net/aalib/"
  url "https://downloads.sourceforge.net/project/aa-project/aa-lib/1.4rc5/aalib-1.4rc5.tar.gz"
  sha256 "fbddda9230cf6ee2a4f5706b4b11e2190ae45f5eda1f0409dc4f99b35e0a70ee"
  license "GPL-2.0-or-later"
  revision 2

  # The latest version in the formula is a release candidate, so we have to
  # allow matching of unstable versions.
  livecheck do
    url "https://sourceforge.net/projects/aa-project/rss?path=/aa-lib"
    regex(%r{url=.*?/aalib[._-]v?(\d+(?:\.\d+)+.*?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a4aec0f6a61caa07dcdfd47a8579ba4f506b1047cc0b822fe0321e123e638764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "404c97537d65ca0b75c389e7d439dcefb9b56f34d3b98017669eda0d0501add7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4890d380658f2e1ebef37698c874b8711acfe9c0685313d8c93dbe2e9e08bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bbe40492b5ff2d6bde6effd36a8fa0b179786032c1da624d0f6bd15e71cd044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "292e704fb6cca01e6ab77baac8960df5c9b45f2fb209a0f670a7de16242c3ee0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "031eac9658cb6878fea6b53e232e0b3f294b81953dd1803bd808c26c5b1a934a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bee33852c86c2dea5017369281ec0e4d56249d4bc7d2803f1c2794c8773b92d"
    sha256 cellar: :any_skip_relocation, ventura:        "a71c6ea0888e11ca4512de9bab4142c160e360e41ef5eb761740af5f77a459cb"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7c8f7dafcb3eedf34abdd258d0cab1f9e58a3048da6307ded8ae029d162a2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb1df93a418c2ae4b7c358d19b58afc0ad73d9d1e6f22b92aa5d5f086cb48a70"
    sha256 cellar: :any_skip_relocation, catalina:       "d83c1b827ca16ae5450356db32fe1b27e910a27bbe2b074a9b4c22fe310bc5b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6205456db777cfa9097a0285ef6fdc29876b21df831295a0c9f2837ce236fdda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba926f8aadec9e5c30880ae6e6497d44f9045d1ca1f680baf28e67309bd8ecd"
  end

  # Fix malloc/stdlib issue on macOS
  # Fix underquoted definition of AM_PATH_AALIB in aalib.m4
  # Fix implicit function declarations
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/aalib/1.4rc5.patch"
    sha256 "9843e109d580e7112291871248140b8657108faac6d90ce5caf66cd25e8d0d1e"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    args = %W[
      --mandir=#{man}
      --infodir=#{info}
      --enable-shared=yes
      --enable-static=yes
      --without-x
    ]
    # Help old config scripts identify arm64 linux
    args << "--host=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/aainfo -width 100 -height 50")
    assert_match "AAlib version:#{version.major_minor}", output
    assert_match(/Width +:100$/, output)
    assert_match(/Height +:50$/, output)

    output = shell_output("yes '' | #{bin}/aatest -width 20 -height 10")
    assert_match <<~EOS, output
      floyd-steelberg dith
      ering. . ....----:.:
          . .......-.:.:::
         . . . ....---:-::
          . .......-.:.:-:
         . . . ....--.:-::
          . .......-.:-:-:
         . . . ....:.:.:-:
          . ........:.:-::
         . . . ....:.--:-:
    EOS
  end
end

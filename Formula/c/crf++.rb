class Crfxx < Formula
  desc "Conditional random fields for segmenting/labeling sequential data"
  homepage "https://taku910.github.io/crfpp/"
  url "https://mirrors.sohu.com/gentoo/distfiles/f2/CRF%2B%2B-0.58.tar.gz"
  mirror "https://drive.google.com/uc?id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ&export=download"
  sha256 "9d1c0a994f25a5025cede5e1d3a687ec98cd4949bfb2aae13f2a873a13259cb2"
  license any_of: ["LGPL-2.1-only", "BSD-3-Clause"]
  head "https://github.com/taku910/crfpp.git", branch: "master"

  # Archive files from upstream are hosted on Google Drive, so we can't identify
  # versions from the tarballs, as the links on the homepage don't include this
  # information. This identifies versions from the "News" sections, which works
  # for now but may encounter issues in the future due to the loose regex.
  livecheck do
    url :homepage
    regex(/CRF\+\+ v?(\d+(?:\.\d+)+)[\s<]/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:    "6dc7eda56c3ad4d066a9f4a244ec02d9bdb4b1fe482abfd632fdace270c68936"
    sha256 cellar: :any,                 arm64_sequoia:  "af1f4415e133ec77e5dddfd4d967b16069928b8da16a49ee2fa27c77cb3ef616"
    sha256 cellar: :any,                 arm64_sonoma:   "a30d515cc61679d50afd7639ee093286fc343c2dcc6719f53b38413196673bb7"
    sha256 cellar: :any,                 arm64_ventura:  "b2ace94562fd7e5a8abd1d05d40511e346e7a49ee504c448eba428f8c3b8a9db"
    sha256 cellar: :any,                 arm64_monterey: "3a9ccdc1221e5b2516710ef51b3b50473d7d580f2676fca2c8f69cabcd7e6f61"
    sha256 cellar: :any,                 arm64_big_sur:  "763da462b53ce92f9feae23750b038b96e79b121b7bdfa4c0d1c99701c3345d4"
    sha256 cellar: :any,                 sonoma:         "9745ec5432d1ed8f4f5dc546e35fdfc82d4f5e723eb4065f298a2e46478d9911"
    sha256 cellar: :any,                 ventura:        "1233d831712132c1221d609f9ea56f217179ccae1d93c2fdb288efa2077d9eb0"
    sha256 cellar: :any,                 monterey:       "37c3083f194d7a03c220805f33d1469babee06cf05d0938a44f4f47a023dc86c"
    sha256 cellar: :any,                 big_sur:        "fcf0862271c392bc7b69a4e02a74dd9bd85615b6be0273009e7611bb78298f61"
    sha256 cellar: :any,                 catalina:       "6706e1cb8b242ed58885402da7b41cd1552f206407fc18c200907f3c64a7b9c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e1b5ccbfaf09a9ce9fbb265f798cb224a2237dc4728b7348a304a0fe3d412602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc105b0deaa5661ba6cde2ac18b289ef676aacfad93f569e659d1ce6035127f"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end

  test do
    # Using "; true" because crf_test -v and -h exit nonzero under normal operation
    output = shell_output("#{bin}/crf_test --help; true")
    assert_match "CRF++: Yet Another CRF Tool Kit", output
  end
end

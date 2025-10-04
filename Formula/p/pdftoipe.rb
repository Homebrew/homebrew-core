class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 10

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "963700600ea943f69ca9c77a5efa04ffb52e0e82b68de64aec105dc337e14fb8"
    sha256 cellar: :any,                 arm64_sequoia: "4cb6ee7067d29c1ec17a192f6cbd6d756ed510bd8dd932bfc8511b7a696e8fdf"
    sha256 cellar: :any,                 arm64_sonoma:  "e761b956dcdaa5d5e5d43044662b07289c0bc8fceb78bb60dc63d05c9e6d8c32"
    sha256 cellar: :any,                 arm64_ventura: "f94a45d24f66f8be3f5253c3e03269fc936f80fe8cbf76940eaea6473364a7ef"
    sha256 cellar: :any,                 sonoma:        "9f49c005530ea59eea9bda4aebfc246096683253bb33673db030b14a7efcb081"
    sha256 cellar: :any,                 ventura:       "eb3372709225584047545555b56b398589d9274a201e4574fa3804928a2ae27c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b3ee07a0a7b043e6987109e113f5c4e23c0cc9f7750383ceb2e0e27614fe34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141da3c9bc5dcabd8a8162aefdc037978c18abf412e3ced84e1aaf9747240216"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end

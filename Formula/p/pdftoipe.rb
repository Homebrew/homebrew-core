class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 8

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73ef0b93cb20c5a6f607856003175f96a3185859c409181709fb3e0d34cba4f8"
    sha256 cellar: :any,                 arm64_sonoma:  "3c5c3ae4556a3dad3b1f891b325613edaaaf193474574295cf40d6dcf37651a3"
    sha256 cellar: :any,                 arm64_ventura: "884f0b8f60c43651be7ae0a08873855b9aecc86ac4c58a72760fd7d11914b05e"
    sha256 cellar: :any,                 sonoma:        "53fc4df76a9e88347b9a531d4e9f6f8272a76af2b021b700dfb32a82b3d12f72"
    sha256 cellar: :any,                 ventura:       "482f5b67b34e9f392ede0a2a7d1670fea573f0c090d64923ce498e6fa1592ec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9294b423b731fb9e82da7f949dde35f864d74a4040429459546d6fbac76a0a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225dd057b1255d16f2d639f8b2457a7ee3a3a059b7e791c48a457c8043120d0e"
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

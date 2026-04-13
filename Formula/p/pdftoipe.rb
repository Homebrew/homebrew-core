class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d03ef959988c64da97def94a529639a77b292bdcea74b4f2538ac57a4b939ad6"
    sha256 cellar: :any,                 arm64_sequoia: "58ec8c1ec4bf463395e2100548a58440639183caf2a1db1628a73dd0639b4f50"
    sha256 cellar: :any,                 arm64_sonoma:  "41fa2fc3ff7eeed0edd975de4dc01124c17f304193f4945014d891e7e1d680b9"
    sha256 cellar: :any,                 sonoma:        "2b79b842085ead9e41b05c9be48265a99b2d16a0b5fb59debfb42754d454a9c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f845ac530a019acd1eb3c2d190beaf2c5e01b525347531b0440f0ef912a9556f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1215c00da3c1a1b309dd42e5df4e83eda64b19958f42ecc22da464254eac0b87"
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

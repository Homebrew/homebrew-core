class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.21/pdfcrack-0.21.tar.gz"
  sha256 "26f00d4afcb70b5839047bc6f62e4253073ac437bdb526f01e8c04b220e97762"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69a134ef06d1ed838be0243f923f5cd403b32a4ca83adc619bda46f6d58ef91b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52236fa60b8d96b8dc015eff612a68f9d5932150fe37b924e1d56174149929a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d34c847b5985a302ae965861ec1d3966475b23f17419f7ce18b6dfe8c57ff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e2cd7962fcc95cac7272e42ce86b9698655398a4d370c09f1a883fe7ecd1bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf7fb52544eb4f38866ba36569cfa621c92fd887c150a11cf05d4a5daede1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57887b2e4d09083f00622af759046fecde428a6dbcdc736a30f0f8eec18a6e82"
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end

  test do
    system bin/"pdfcrack", "--version"
  end
end

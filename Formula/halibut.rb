class Halibut < Formula
  desc "Yet another free document preparation system"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.2/halibut-1.2.tar.gz"
  sha256 "1aedfb6240f27190c36a390fcac9ce732edbdbaa31c85ee675b994e2b083163f"

  head "https://git.tartarus.org/simon/halibut.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52d1b558f693989ad6a5a0f78edb984a4d4a67a559a6013b29c3a6aee31a4937" => :sierra
    sha256 "3499646cc8fb4fc71c87743b0e27ab5fc37b7b72e03b2ff3cdf86b3809ebda7e" => :el_capitan
    sha256 "db13c78d65619b0b602a83d9641afdbe4d603492bc33bab263ae2530630578f4" => :yosemite
    sha256 "eedcff72763e75094aadb2a05115614484a2e46561bb11a0466a98153d5dbcab" => :mavericks
    sha256 "acf6e1989f0f9f895f36b4076179bc8f30fb37be5537f02a1c2f5b0733b8e7a9" => :mountain_lion
  end

  def install
    system "make", "prefix=#{prefix}", "mandir=#{man}", "all"
    system "make", "-C", "doc", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    (testpath/"sample.but").write("Hello, world!")
    system "#{bin}/halibut", "--html=sample.html", "sample.but"

    assert_match("<p>\nHello, world!\n<\/p>",
                 (testpath/"sample.html").read)
  end
end

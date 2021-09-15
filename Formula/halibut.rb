class Halibut < Formula
  desc "Yet another free document preparation system"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.2/halibut-1.2.tar.gz"
  sha256 "1aedfb6240f27190c36a390fcac9ce732edbdbaa31c85ee675b994e2b083163f"
  head "https://git.tartarus.org/simon/halibut.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bbe2900f2e05ece4838ae138e287192fce7c97ed648994f15b19c91304e26154"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f3dc434449de2f5d18bb5019dc62a966cba2981eb88d59d77d34b2049e44f2d"
    sha256 cellar: :any_skip_relocation, catalina:      "e9bd74c1ab130f4abc824906bf1f73f910032a4c7c0938798f7fbab2f1346020"
    sha256 cellar: :any_skip_relocation, mojave:        "05f0236c180aeab690979615812fb72642e7cdeaccb35ebb865a53aadb35e7c6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "fe74b9670ae0d996a17de4a70a140365d057a83a643125dcbd16b33dacad9f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37d878d7f5d8a0869220fc00abdad12f298da1cdb1d2541b3f66793f749e9b4"
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

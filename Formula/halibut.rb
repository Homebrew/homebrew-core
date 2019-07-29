class Halibut < Formula
  desc "Yet another free document preparation system"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.2/halibut-1.2.tar.gz"
  sha256 "1aedfb6240f27190c36a390fcac9ce732edbdbaa31c85ee675b994e2b083163f"
  head "https://git.tartarus.org/simon/halibut.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0c6d4b0a0bb643fdba227567efccf639163dccb08b3fdc65cb8c4cf4530f419" => :mojave
    sha256 "34dd7c9fb1fe023d33b61be5bc56c0497a1854b9bbf68cc80facf61ecee68190" => :high_sierra
    sha256 "68325d87dfa9989331273f70ab5edb19c9ca825316df64cc860edaa43a5d9ce5" => :sierra
    sha256 "7f10669422a452000a9150206e8e675dc5b0b180d0cc95d02436dd566a6974f1" => :el_capitan
    sha256 "6aad05089e904d5695aac53b6eac97e08b0e28b0e1b5d0dc70ea91864543558f" => :yosemite
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

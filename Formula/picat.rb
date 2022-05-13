class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat320_src.tar.gz"
  version "3.2"
  sha256 "b72edbb3b81e1e74f6a5dc994587a2b0fe2b3ed123d809ca0fd6b0c171bcbbb0"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "b84887862b7032aceba873ce42528c8a0e21e179fd52e21deb4347236b4ac494"
    sha256 cellar: :any_skip_relocation, big_sur:      "c2bab63b9ff03ab95976728278ff48129e39dc3d337dddc6f9cb7e7d59c7bdbf"
    sha256 cellar: :any_skip_relocation, catalina:     "f7560160e68ee4b3da817e9dfffb02b52a3063ab24e83f94153f8115735efa8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2cf3631d604170ea3bf6cdaa1d70a82b50f21538dc2f0652c428b74fb0c416cd"
  end

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end

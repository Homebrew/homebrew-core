class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat312_src.tar.gz"
  version "3.1#2"
  sha256 "eb13be811d9470420d8d9e488f1f4a7771a934e3b27120aa6529648d5a070d9e"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "9a6567ded5a5cdacb7f454715beeca4cae6590b11c28cfe172388751567807c4"
    sha256 cellar: :any_skip_relocation, big_sur:      "aaf2ef1f21a19c8bf60b5ed7b52b91f12693babdaaec8edb458b888e6f748838"
    sha256 cellar: :any_skip_relocation, catalina:     "40e9b771743f9799af5c2abc091a3099faeb0a14be8136d5aa3fea1624c67d83"
    sha256 cellar: :any_skip_relocation, mojave:       "248ac7a621f9b9f860170dd1bf57aafd6f785e35140d58c2a563fbd4e6604a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7b15831545abe443fa02911fe09ea411bce3b2be30cb22f1da47a6434667e8d3"
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

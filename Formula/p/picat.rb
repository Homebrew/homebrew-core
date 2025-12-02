class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat394_src.tar.gz"
  version "3.9.4"
  sha256 "740622576cc6d99d35a81b21b2a3912fda11d8dbcd9d16afbc648368e1097439"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f91317152f8e9606dd659aff7c47667047356dc0b9cf5a61013883a931eef4bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4efe81777466562f470f56f4111f11852b187014d70f8b514a8462fcf0b91b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e41ef0585e81fa898a4e2779a74fee34b4dc4670bb702bae28f43378841e1c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "13c07dbfcd81afa71492936367de432adbfca0fb8beeb79ba8c1f31cdde76110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49145f401e18cb61f2325d327b9a96170f92a037f67aa66fa27cd941a38b4027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963666619b07ea68fe3f1bb0cce0c0eac5feeeed4b43a1446b1607f3a93bf158"
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

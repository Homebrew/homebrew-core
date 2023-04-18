class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat34_src.tar.gz"
  version "3.4"
  sha256 "dbd990bfb4cb2367aba005b4848043d44f4d091d4f1d7699d77843afd0320a64"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "873daa47f3147bcdccafac45f462ab1ab08865cde0201fc5ddd75939a7296397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3efd32e18d375401fdc7af5f57c5573e0d9d2ddf10a7bf57e75bc9ae8a5ab010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "559368f4020dea145e25b20e4387ac6c6af3c8d45079254288313ee895610370"
    sha256 cellar: :any_skip_relocation, ventura:        "bf2c284a23f03b11a7e32344b68538ccc0e22e2edcc9a2d6ee0a410b15e6803b"
    sha256 cellar: :any_skip_relocation, monterey:       "373561b87c53856650846d37bb2d30156bdffe07fb30471703705db18cbd3ae8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f992d81f49269822bc31e28aee899b920ad8993788b99dbf5bfcd46dd63eda9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9efa62ebb105a7e7b51fc4701635ac3a4c68ec9f0b47cb00911867fdfeaa592d"
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

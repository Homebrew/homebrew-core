class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat39_src.tar.gz"
  version "3.9"
  sha256 "1d5c8bad46da6017b6fa72238fe38968f6c53d66ab744202eb9c07114b0a19a9"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48eff97f8df158c9421a0d343a4e89e1ead7a7b845ed40d43b11fc951584ddfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ac9b07f0f34278049cef38e0eb2228227cd97733f259449c8d206e508b4b94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "268d96345c612348601b1fde96e800ec83f29a187acf66a04a03ddb0979cd9bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1685ce9e3bb7d3416d8c1fc7f06bb0fe0bda1939a66abb7327414cc79fdeaa2"
    sha256 cellar: :any_skip_relocation, ventura:       "646aabc4032bca75a228f67923d20443587c27c2f3aba539c074d7003a00de99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80b733c4dac8c71e2bd7af06d6b45db948d351fb5147aa1fbec81e2b45137741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac1b5b8b0ce4a7d9bd346f63e291359eb352832eed68277e2b199dbbf44021f"
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

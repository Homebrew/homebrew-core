class Pixd < Formula
  desc "Visual binary data using a colour palette"
  homepage "https://github.com/FireyFly/pixd"
  url "https://github.com/FireyFly/pixd/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "011440a8d191e40a572910b0ce7a094e9b4ee75cf972abc6d30674348edf4158"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a4d99285c81b2948df43e3e25515596d12980af8f535419d1665ba77b5ef33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c41c69c03c8f20507a9014e41e7e02cc6813abe0c919ae40a16f82e0b01fe899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d31f44763a25c242c3b0c55433e3c3615e61b1db85dd3729fab3f69468661b0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04df14dafa37644469c807bd9d00fe86ff95186bb8e068fcbc01bc7b0ce95acb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac1c7187b65cde2b4061710214b5a004b2f05f1d692b69d042327b9d9b319eb"
    sha256 cellar: :any_skip_relocation, ventura:       "f04e390bac553c784c3cc78f5b5a3113fe23c42e9ead74cd886014e87d72bb96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f986efd6ff8664144233f39b4f3f2118b97b2387ee1373ad66e538c48a666d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa387cb2dd091d0b261fbe63ff989362f7f9269a0565f68ff1fe5acfceb16167"
  end

  def install
    bin.mkdir
    man1.mkpath

    # BSD install does not understand the GNU "-D" flag.
    inreplace "Makefile", "install -D", "install"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "H"

    assert_match \
      "0000 \e[0m\e[38;2;147;221;0m▀\e[m",
      shell_output("#{bin}/pixd test.txt")
  end
end

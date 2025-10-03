class Pdftohtml < Formula
  desc "Utility which converts PDF files into HTML and XML formats"
  homepage "https://pdftohtml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz"
  sha256 "277ec1c75231b0073a458b1bfa2f98b7a115f5565e53494822ec7f0bcd8d4655"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/pdftohtml[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d4d29ea04949e3054a63667e1563e018cf7b289cee59357ee46955d70f47f6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09de57926ddbd85906d6ed7dabf427f6314d13cab5de1c0e073a1288a3ea0b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb5b6f4137fd05ae7158f74fddf056193773308ea7195ffeec203928ac0bb52c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a18be87eedeec7c2bb94b6571e532ac3e04abf21567991c177d53f6740c71767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ddb14280f6046adac64bd2d731483b8bf97cd9f8bd61a52f1f7b95b608febe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d5a75c1351339a1e1cee32c585172bc638503e4fea57232532daae41bbb2e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9daa1524d85414bda2e30ab99e13f958a3d7620f6d40d74792bd7b841695ad91"
    sha256 cellar: :any_skip_relocation, ventura:        "74cca150680a622965a061c05bbe754e80c63232b6b35db8508136313321d6b4"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5979a8c315cdbe2babf1a576e86259956f129d67b416fe62dd9a5b51bc9c64"
    sha256 cellar: :any_skip_relocation, big_sur:        "17a699cdc73b7674f537adec7ea8ad696374921c84a52dfaacaa05882f5696da"
    sha256 cellar: :any_skip_relocation, catalina:       "d8a6e5bb1d84ee766898543d77307b4a9a6e6f826ebe9cc48ce6db8bb24c8923"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0356296698624d0111e7352dfef0d7c63aa1523144829b524f86b60d94f3021b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e13127c7d0eeaa1dd9be51dd46644bad7fa0864849aa6476392e0f5c7b7561"
  end

  conflicts_with "pdf2image", "poppler", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "make"
    bin.install "src/pdftohtml"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/pdftohtml -stdout #{test_fixtures("test.pdf")}")
  end
end

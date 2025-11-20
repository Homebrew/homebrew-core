class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/"
  url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.52.tar.gz"
  sha256 "df906463105f5f4273becc2404570f187d4ea52bd5769d33a7a8661a747b8686"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/download.html"
    regex(%r{href=(?:["']?|.*?/)gocr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "22d93d120980d188dbee305cbec8c1d22aab0a9def0580ff3ecaeaa44fe488e7"
    sha256 cellar: :any,                 arm64_sequoia:  "f38bbed5dfe8ae2150cab6f508e71dc9402d9f05c3c72273f3c9270dd42ff6fa"
    sha256 cellar: :any,                 arm64_sonoma:   "0d859924dd354cc1c623786533136a7ecded331ad47565f208f954ad7091e957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e2ae4571c3fede1d3af4d0c46a09179275af8c8506d54843a7a01f55efc712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e3f30e26e5c707e006cf08ebe4043b8f4bced950ce61bb6ba2e7926797d0a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e18ecb5d37e3105891f5ef43b6e81dff52cb5148e1425a42bdc7c5a71f106ddd"
    sha256 cellar: :any,                 sonoma:         "8d1a2d42e8c6063d35390c128c34ee66420912b9a78c37dbf5c015cff1ac1d58"
    sha256 cellar: :any_skip_relocation, ventura:        "44bfd6e6d26d3554a8cf204e053adfb063b1bcbe3d7c62e2d8dd6814e53b8498"
    sha256 cellar: :any_skip_relocation, monterey:       "43d025be56c56b56f15621742a716f1c6ad7d645a4c2f4ceceb0b85f63ec2787"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d0cd5d85d36fd7e34ade41d36f49628323f81f2274fc3de1654d8b3b837c90d"
    sha256 cellar: :any_skip_relocation, catalina:       "474d44b25c0a812587529d2a2c75f49d8e45760c2c2f35d6c73a495cd0f4e055"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4012b5d2e3c64d8bffa02852c25348f57cee8475aa726d7e14384e248a08e349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "614341527ffeeb9e65ea13c95c230569bd68316f11b6e4c3d5bbc4c46757faa8"
  end

  depends_on "jpeg-turbo"
  depends_on "netpbm"

  # Edit makefile to install libs per developer documentation
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/gocr/0.50.patch"
    sha256 "0ed4338c3233a8d1d165f687d6cbe6eee3d393628cdf711a4f8f06b5edc7c4dc"
  end

  def install
    system "./configure", *std_configure_args

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs"
    system "make", "install"
  end

  test do
    system bin/"gocr", "--help"
  end
end

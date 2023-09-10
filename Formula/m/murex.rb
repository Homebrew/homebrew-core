class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v5.0.9200.tar.gz"
  sha256 "090df13ded73936d884c13dc5ace7badc658744841edb614011ff882d1ac560c"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a83b7fe16e332b17c6c53f8c5e8368e730784e2327c67755e68e4a7a159ade4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aeb48a8e9ce4cfeab7eb53b7ca0f7e0843cdf14c788c1bf6132c257892f72d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7116e3de180f05a57d1d244d8138db99ff518618e88e16662e752996da4cb73a"
    sha256 cellar: :any_skip_relocation, ventura:        "c53859e410c4edf94df2d8169f410086c834f880b84df8e938c9d0efa298c1a2"
    sha256 cellar: :any_skip_relocation, monterey:       "65521ad5e77a64ce28a5d24d40d69a6c64870ba2acf894b5697cce2da55b4918"
    sha256 cellar: :any_skip_relocation, big_sur:        "875d6ecf6a1a4270eb5b0ded556c1aa3d074e51df8bc9ccae29a25941e6c2a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2bcf5ce83e9dac9f75bf36ddada6da55ff5e882e1ca091add1c83fd47195314"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end

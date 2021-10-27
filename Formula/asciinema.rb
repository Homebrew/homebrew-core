class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/2c/31/492da48c9d7d23cd26f16c8f459aeb443ff056258bed592b5ba28ed271ea/asciinema-2.1.0.tar.gz"
  sha256 "7bdb358c1f6d61b07169c5476b2f9607ce66da12e78e4c17b7c898d72402cddc"
  license "GPL-3.0"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fea4ae9e201966f38b7b1d5a5edd46f047b8ab80ca382e5a4d218081ae5c8d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fea4ae9e201966f38b7b1d5a5edd46f047b8ab80ca382e5a4d218081ae5c8d5"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe5b03bd3cb9eec10a3c4627e02421abe10ab1c96e264606d2bf5254914152b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fe5b03bd3cb9eec10a3c4627e02421abe10ab1c96e264606d2bf5254914152b"
    sha256 cellar: :any_skip_relocation, catalina:       "3fe5b03bd3cb9eec10a3c4627e02421abe10ab1c96e264606d2bf5254914152b"
    sha256 cellar: :any_skip_relocation, mojave:         "3fe5b03bd3cb9eec10a3c4627e02421abe10ab1c96e264606d2bf5254914152b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "388d5d894e1150768c822e978ec7c86cd62a1e730d98eb5055823dbbd728d7a8"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end

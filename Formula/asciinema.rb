class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/2c/31/492da48c9d7d23cd26f16c8f459aeb443ff056258bed592b5ba28ed271ea/asciinema-2.1.0.tar.gz"
  sha256 "7bdb358c1f6d61b07169c5476b2f9607ce66da12e78e4c17b7c898d72402cddc"
  license "GPL-3.0"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d5e336d2bd6243bde6c6809397b08f94012b6d0fdce0220845f17e10e198637"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5d4f11d283d8dfd88e9a9de63af990e9e9d2eb08a4df0a9efc162aa99756c60"
    sha256 cellar: :any_skip_relocation, catalina:      "f5d4f11d283d8dfd88e9a9de63af990e9e9d2eb08a4df0a9efc162aa99756c60"
    sha256 cellar: :any_skip_relocation, mojave:        "f5d4f11d283d8dfd88e9a9de63af990e9e9d2eb08a4df0a9efc162aa99756c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a948ecf608b65a4eeb7ce16aab70c787b62998605c8d8eaab2358bd78180c5"
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

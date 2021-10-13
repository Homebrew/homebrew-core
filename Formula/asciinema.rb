class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/a7/71/771c859795e02c71c187546f34f7535487b97425bc1dad1e5f6ad2651357/asciinema-2.0.2.tar.gz"
  sha256 "32f2c1a046564e030708e596f67e0405425d1eca9d5ec83cd917ef8da06bc423"
  license "GPL-3.0"
  revision 4
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

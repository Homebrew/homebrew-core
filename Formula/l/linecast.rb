class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/d8/de/4eee771251721d89b6c877e63ac19fe6b6d6283ee1e14e75f4f06cfbc083/linecast-2.13.1.tar.gz"
  sha256 "a52158533e2ebf65138d883fc44eaa55c1c7f0a37d40e99ce52af8b0b356a777"
  license "MIT"

  bottle do
    manifest_sha256 "51593f4d07fc20e25c7e38767b13290de72adca298eeb8af7f728ef1f62cb505"
    sha256 cellar: :any_skip_relocation, all: "ef72df130dafa38eb72733a8424ace2c2bdf7ec44a9ecad0adf5dd70ee1f2c6f"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end

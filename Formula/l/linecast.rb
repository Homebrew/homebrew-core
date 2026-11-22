class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/6d/63/71f3ba72c8ee50597094988b9bef3d9aa7009dd77d664b664d36c4f5ee6d/linecast-2.13.0.tar.gz"
  sha256 "0be004b4e052f299086b2148b1f8a31b2fe90075a3fd54244f46fa5c8a92f365"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3bc572117c6801ae9d56d845ff8c2fa7dafe28698de7a7d365e0479c1acb6fd"
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

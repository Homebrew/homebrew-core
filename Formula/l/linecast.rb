class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/6d/63/71f3ba72c8ee50597094988b9bef3d9aa7009dd77d664b664d36c4f5ee6d/linecast-2.13.0.tar.gz"
  sha256 "0be004b4e052f299086b2148b1f8a31b2fe90075a3fd54244f46fa5c8a92f365"
  license "MIT"

  bottle do
    manifest_sha256 "7ad8af51368d2e05be4a7bd35e9518b7933e1dd37af77806dde14f9327a000d4"
    sha256 cellar: :any_skip_relocation, all: "d9532bdffe390b6f7664bb25170865e2b02baf7c9a1cebae630b5e961b431494"
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

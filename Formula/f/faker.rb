class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.39.0.tar.gz"
  sha256 "4659b04a3caa8a591028c5bf41797799e9f94c034cbf01f7f9c158a0fd2aad2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "769188c1eb0c52c9f51e155002f113bd7ec1a186ee13e3d6413b72f057ea8e5b"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{'ssn': '150-19-7120', 'name': 'Christian Blake'}",
                 shell_output("#{bin}/faker --seed 12345 profile ssn,name")
  end
end

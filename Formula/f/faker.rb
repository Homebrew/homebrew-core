class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.37.0.tar.gz"
  sha256 "4e9482c64a10f1a4b6d975512b2d98c885682f9600ece3d8619230f4e27c0603"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d14a5178caae78b23795c49c35db582620e9b11b9eaab3974ee54f65a0ad67a4"
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

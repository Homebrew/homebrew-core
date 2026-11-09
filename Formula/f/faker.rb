class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.52.0.tar.gz"
  sha256 "2996ba061e7ea3770d4762a7717bd39aaf3514ad9ec1ccf3cf228e24142e3d2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de25b480eba86591d3e2d8c43f54069102e488e2931a741244bacdf750f31cd3"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{'ssn': '150-19-7120', 'name': 'Christian Blake'}",
                 shell_output("#{bin}/faker --seed 12345 profile ssn,name")
  end
end

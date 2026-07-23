class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.35.0.tar.gz"
  sha256 "85089feaefe38d3600f8a80f491199b5ec861b6b6a77f61a8645e89e66a9a8e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3eeda2d8da3606bb4bd329d8a33da2f772094ded333e4d9a6f8a096f05f32aa1"
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

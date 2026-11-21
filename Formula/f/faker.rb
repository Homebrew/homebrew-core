class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.63.0.tar.gz"
  sha256 "5f0c1d0aed75f91675dd04eb9138f4109e966d7aecdcdbca119eb0eb6efa7b9d"
  license "MIT"

  bottle do
    manifest_sha256 "8a925f979313691a2d25553c46b658f837f7b3c2a08c4f850fb45b6934373773"
    sha256 cellar: :any_skip_relocation, all: "82f30cbfd22c5ae6dc3ee26f22f951ec4129fd12c43e2512ef04b4226b843923"
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

class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.54.0.tar.gz"
  sha256 "64d0c3ca542ac4548b4bd5c0b5daddd5e13851aba3e2df55289c692166c34713"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "caf573617f09d7fd3973831194f014547be990151877511bc6bb6b22078896f5"
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

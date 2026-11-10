class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.53.0.tar.gz"
  sha256 "be5b7045cb18f4a43bd768e32d774bd4d513f787b6f13f043043a6aa3a9a3241"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b3a31ad01fd56365bab6ff1fcf2c1da9499988cca8707a4c048d4470b9ec736b"
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

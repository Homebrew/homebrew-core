class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.59.0.tar.gz"
  sha256 "e1c8aa36531db58a2bb5ea104de678f5c28125f2c003b7b5c5259d6ba76d906d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab36b22f22778f08bb09f60b88925713b12eab780cf1b6205498cedf64ecd265"
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

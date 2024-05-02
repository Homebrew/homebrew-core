class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/a5/0e/397db3d2c3568be07fb032c3e232581df81cb9462e8bcd8574285749f519/dunamai-1.21.0.tar.gz"
  sha256 "28d4bf5e8e2f3fe5d6a4de61b05c4c70afaa7c6df55fe0204bb5b6b53761e4bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, ventura:        "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ed1b5d51dad5513bbff1bc8a0584d8b4aa93d546dd7c68e5a5f2d9c96d9a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed0cde65c325304435d77baca42ac3d18dbe0e7ff7a6152a17f13a30bceee4e"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end

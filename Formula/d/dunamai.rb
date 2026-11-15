class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/18/82/51a4e2ed9a7fef19888e5e0ba9a493c8f1878ab89b10b05cc9564b4f5df8/dunamai-1.26.5.tar.gz"
  sha256 "b1435d8d2b0aceef240cde8e8f6ba910e85b1aa0e22fa9e21454d2d22fb0a89c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cfb80651c7320859114df3746d7dcea5118b1393580fdbe08aaf1a79ad2c2e2f"
  end

  depends_on "python@3.15"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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

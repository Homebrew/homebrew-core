class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/a9/9b/44944afb93fd0e1cec69023d5c0a670ee015237de6146eaac926592aa142/dunamai-1.17.0.tar.gz"
  sha256 "459381b585a1e78e4070f0d38a6afb4d67de2ee95064bf6b0438ec620dde0820"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0595c31e068e0730d2a9f801765d5e290d2c4b4c022e1178c47783a34515c80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8da92c2fc7904f9f906e81150579c603dfbffcc2e449085bedf556e4d368d9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d45a7d6becf3b93a3e7760ed6aa7e3db373d712522c0c15871ec22f29cb01e40"
    sha256 cellar: :any_skip_relocation, ventura:        "6e21b8187869d0a34768b455a67490d0a6bbb49e9db36031b23b0c2c0b7d57f3"
    sha256 cellar: :any_skip_relocation, monterey:       "284e6f262a330248329bbba8b5b5990294b7c37993817b16ef24aa247492c580"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d46fee4e3d82ef8c426efa7a435fc2a024613ea865636662fde8190e9a71ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "885255b747d37cd9f64d2c21ab8df4a65cbb8cffb78d6ca47bbd73a339c0f7a0"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
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

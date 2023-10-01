class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/61/f8/416bf0a7ef5775b631305a5772d2c5d67282caeb9fad3fd5181d1742e336/dunamai-1.18.1.tar.gz"
  sha256 "5e9a91e43d16bb56fa8fcddcf92fa31b2e1126e060c3dcc8d094d9b508061f9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caa2225fdf48444298424b60887eb0ed28d486faba484873e907a9bf54c5f6db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2448421f350edb4f4ac76704827d6c30bf33876da7d861f80b4b0aea71b6aed9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db76ded7233363f3f8538f9581fef119a6ab3237e5789a794c6a9800abf1afe1"
    sha256 cellar: :any_skip_relocation, ventura:        "ae43ea2e87c37456d770b6cf85ff38ab8be0565b31d1f3cfbc27032b9280a399"
    sha256 cellar: :any_skip_relocation, monterey:       "532ad466acd49661945263389a234aa81327e31734b5cd8468e42b27aae6c9bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad7005fa07caea1d5c47544192d20786bebf239f9422b14208ca9c605038a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5b62b8f371fb341cc936f76c788111f8eccda2012de87b079ea2af66ee056c"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

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

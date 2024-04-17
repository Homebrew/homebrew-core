class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/04/c6/ca9a7d5365c31e3e8442efe4bd24ced6784ca4b8934b00cdc9f537f700f5/dunamai-1.20.0.tar.gz"
  sha256 "c3f1ee64a1e6cc9ebc98adafa944efaccd0db32482d2177e59c1ff6bdf23cd70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "220d0359c2ab265a889d1e2893769caf2f5b6d9ecbd29c02e042674f04c24f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "220d0359c2ab265a889d1e2893769caf2f5b6d9ecbd29c02e042674f04c24f6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "220d0359c2ab265a889d1e2893769caf2f5b6d9ecbd29c02e042674f04c24f6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "220d0359c2ab265a889d1e2893769caf2f5b6d9ecbd29c02e042674f04c24f6d"
    sha256 cellar: :any_skip_relocation, ventura:        "220d0359c2ab265a889d1e2893769caf2f5b6d9ecbd29c02e042674f04c24f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "220d0359c2ab265a889d1e2893769caf2f5b6d9ecbd29c02e042674f04c24f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a931ddc9fa7f7193476b135e1a2643f9dad810bc07507a54ff79ccdd881356c1"
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

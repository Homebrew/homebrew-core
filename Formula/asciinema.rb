class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/26/40/20891ed2770311c22543499a011906858bb12450bf46bd6d763f39da0002/asciinema-2.2.0.tar.gz"
  sha256 "5ec5c4e5d3174bb7c559e45db4680eb8fa6c40c058fa5e5005ee96a1d99737b4"
  license "GPL-3.0"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5416d829853d3186c679d81514f2b7dce82a1e944ad36f7b25d2983a92ba1d42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe8c73c61de79a176c81b799b9abeb441a4851e8caaae33579a7c47562f14166"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e05d3040883a15f3a41530dcd6f0ce837290d4df30b49ff74f717ab2ddd1274"
    sha256 cellar: :any_skip_relocation, ventura:        "20c7c37ceec4bc210ee8eba14cc21e52975d3c0f6e4ccffdb90fcb339d6d0938"
    sha256 cellar: :any_skip_relocation, monterey:       "42b420d084a59d905e65dbd4f6bbe2f4b2acd2c61f8e7a1e88528e18bf998815"
    sha256 cellar: :any_skip_relocation, big_sur:        "4030f7b1ef8bda0f339671002010706457b6e2f29f2d90bd6e18880ba140bbd4"
    sha256 cellar: :any_skip_relocation, catalina:       "13800c6a25e6cfd1565168754513b0632acdeb52044478afdbf9452bd919eb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec302dac1a74b6cffeb6ca21f3f79c12a63db6413afbf1b71d46c2ee29cc6d2f"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end

class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/26/40/20891ed2770311c22543499a011906858bb12450bf46bd6d763f39da0002/asciinema-2.2.0.tar.gz"
  sha256 "5ec5c4e5d3174bb7c559e45db4680eb8fa6c40c058fa5e5005ee96a1d99737b4"
  license "GPL-3.0"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7156153fe5acb94ceefbcfda04d2e85a1e360746ae8a664483bb3c317bbc9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "875fa2c3235403134afa78532bd65e97709f7660ad7d1f6452c119acb04cf877"
    sha256 cellar: :any_skip_relocation, monterey:       "d559e0bd651c20fbd3af3dcaf1723cf711f2bdf9f4614bf8c6b4815b98c6aa03"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a7cd8ba3389f298b673403020b9bd290e3da2a5030d8ea447bb2be98fe8ebf5"
    sha256 cellar: :any_skip_relocation, catalina:       "1a852bcd64112ff5d16c76c558871fee755f17d3feb71bc7bb0401830b8fdae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5777ace4f226567175cf753959964e78f12ac98cd77dbe9752ace1a87fda0bb7"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end

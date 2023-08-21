class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/2b/78/b57985f4efe85e1b49a7ec48fd0f876f75937ae541740c5589754d6164a9/asciinema-2.3.0.tar.gz"
  sha256 "db8b056c00e9bbb2751c958298b522518c4bd80326d90bedab7f8943c7a494d5"
  license "GPL-3.0"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dae7f1d9929f2038918cb726b9ebfcb8c799ebeab382d4cefc66b19bd11415a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19b1b2088615754f5ac48a0678a13747ca2c993401b6191a2ac12ea3e0bfbf8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4ddfa118137c9f06e75af99db2b2a116fd8012fe4dfd299eea7a804d30d546f"
    sha256 cellar: :any_skip_relocation, ventura:        "db4188518aade133a74961306c063b5100adcdbaff8b2c868ba137a1caa50be4"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd2a3729306568bc7a1ca034a364fe0e62526715a8068d9a4bfa0e124abb22c"
    sha256 cellar: :any_skip_relocation, big_sur:        "be49b0dc0c626328a2263ffd2cb516d6f7ab1f8a10ba48528e06bfb64239108e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f12203e93e58b0f689d3c4ebac81bc2d507bee2ff38278023f68852b8c19de61"
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

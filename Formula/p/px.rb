class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.5.6",
      revision: "b1aca3e6556119afe816c4750c921c8dbfdde1a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb3fcc58593d79f98241bf8cb3d97d11a508160c9b20cc20e41d06eb144c131"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae420a972cbe7d2625b24af048b6bf26ed2d34f92fa2435832ef91dcd1a538fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f25bd7bd46fc9d89e24818596aafca798d6f107e0e52b354af7e701bae03aa1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b87717d2ec82da62e3d6ad24e7d335cfd1e2ecedc524492c86676c6ecafcb638"
    sha256 cellar: :any_skip_relocation, ventura:        "25390d4874f01c867651e7e4c9bd5ba11a0629c6ecb203e298acf1edb6aeeeef"
    sha256 cellar: :any_skip_relocation, monterey:       "6147857916476c5d365d670065567b420bc69fadef289526b8c514df814bdb4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5d62a1d5185fff836a76ebb15803fde33a78fa09d38c1355bc3f054c2c4579"
  end

  depends_on "python@3.12"

  uses_from_macos "lsof"

  def install
    virtualenv_install_with_resources

    man1.install Dir["doc/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px --version")

    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end

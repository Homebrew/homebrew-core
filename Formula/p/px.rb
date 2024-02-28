class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.5.6",
      revision: "b1aca3e6556119afe816c4750c921c8dbfdde1a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bdeed53bae7d9306ec3d399640c21f9f46ddc0e231716c100ead74b9549b6a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "020a97f569c8f250a8e3710d277b4bb04633a881969a0530111a672fce979eec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81209f84ce78e366e5adbcc9d97fc700c4dbe149ea1c3e56c993119414a54ec8"
    sha256 cellar: :any_skip_relocation, sonoma:         "69e6f9a47d84ab4f07f6381e289a41de486f08970aaf51543a925385401b35d0"
    sha256 cellar: :any_skip_relocation, ventura:        "72040536ef990aa99491c3eec0c44db58f9366b3cb83f4991d5f318bec3b3069"
    sha256 cellar: :any_skip_relocation, monterey:       "c76add2c718ae1d42f8b31f21602b67834f507b05bc692f9572a5ce46fcef9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176278099f84d934a4a8e4aa9fb53a57ec2e387e8766c2ff8500accc396b6754"
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

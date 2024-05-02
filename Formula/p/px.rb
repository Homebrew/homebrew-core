class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.1",
      revision: "c21398cd8883992497e2644f150b273a275d1980"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb8896dc9c4531acd2e96aa18af6b18108d3f558300cfacb764421139c82bfe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb8896dc9c4531acd2e96aa18af6b18108d3f558300cfacb764421139c82bfe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8896dc9c4531acd2e96aa18af6b18108d3f558300cfacb764421139c82bfe1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1967622930716ff46a0ae1da38c420a8c84f802207202f55410f960b24699b9b"
    sha256 cellar: :any_skip_relocation, ventura:        "1967622930716ff46a0ae1da38c420a8c84f802207202f55410f960b24699b9b"
    sha256 cellar: :any_skip_relocation, monterey:       "1967622930716ff46a0ae1da38c420a8c84f802207202f55410f960b24699b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ee7bedac71659cb3f2621b5a14e8fa33800b7c84eb9b76350d91b233a37ffe"
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

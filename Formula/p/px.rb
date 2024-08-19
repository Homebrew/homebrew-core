class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.2",
      revision: "a95575334561ee533259a37f546e60107f4f714c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "954abfbf9103bd5a34734155916a34d47eb9a41bab2d7e93cb1f53370a5ce5d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9287f2265dc5a0a8ed1376186864d1f5ff177e4e349030bf366446e01585f911"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb8aef248946e9047ede72f1baa2bd0f1eda680f54e63fa057faddb91601c51"
    sha256 cellar: :any_skip_relocation, sonoma:         "23193b94c5f04b9ebbcf1ae71a2bf3d75c2903c94dbbd44b82f946b19a72eee6"
    sha256 cellar: :any_skip_relocation, ventura:        "0347dfb5b55b98f4a749fcd178c872ed3e951ffee725e5db285a1c681e23d949"
    sha256 cellar: :any_skip_relocation, monterey:       "870e626fbe649b14442183da3aa56bfa2f2722e5049243c73b8005e5883ee92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b68ba0e889edf3ea72000165267b1a4de54c025ce717976e5c1f903c310487d"
  end

  depends_on "python@3.12"

  uses_from_macos "lsof"

  conflicts_with "fpc", because: "both install `ptop` binaries"
  conflicts_with "pixie", because: "both install `px` binaries"

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

class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.9",
      revision: "e4c9737b03ba8533cc3428524effe1028bd4a7ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93676a71991183f97c382f497977592ad790921ca2693e46dab05dd7ed47efc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93676a71991183f97c382f497977592ad790921ca2693e46dab05dd7ed47efc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93676a71991183f97c382f497977592ad790921ca2693e46dab05dd7ed47efc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4bb31761956dc9ef1e49a06ec566b39062453be62159b534ce7ec5c32ad014d"
    sha256 cellar: :any_skip_relocation, ventura:       "c4bb31761956dc9ef1e49a06ec566b39062453be62159b534ce7ec5c32ad014d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f35ff630e8bbe3e8f7289e0f72845ca6ad81c95ae4ab500bbdb76578fce5c905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93676a71991183f97c382f497977592ad790921ca2693e46dab05dd7ed47efc9"
  end

  depends_on "python@3.13"

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

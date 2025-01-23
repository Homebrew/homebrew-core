class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.5",
      revision: "837bd0e16a0abfd4a315f7d240d6227a6b861e07"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4350398d48afc4a81e5ab15545d9203c0213e5cbf7a78c2f5a9ebc5c37695c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4350398d48afc4a81e5ab15545d9203c0213e5cbf7a78c2f5a9ebc5c37695c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4350398d48afc4a81e5ab15545d9203c0213e5cbf7a78c2f5a9ebc5c37695c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b792aaadadd03222ca09221ce9b5769ed0e1cf941455c2ec2cde90f11399ce27"
    sha256 cellar: :any_skip_relocation, ventura:       "b792aaadadd03222ca09221ce9b5769ed0e1cf941455c2ec2cde90f11399ce27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4350398d48afc4a81e5ab15545d9203c0213e5cbf7a78c2f5a9ebc5c37695c7"
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

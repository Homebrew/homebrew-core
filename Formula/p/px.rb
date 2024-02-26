class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.5.2",
      revision: "584f919429f1da41661d87b59305347680fb0a2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfbce983a56a6cced3dbe043966be5d7a03db965e9010792e35323a4109c2cea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e191c21a2a3ae3cb26ca838fb38e098fa356f7bc7d6f4b6ccccf2a6f6ab6c36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "672be80ea811076afd74fc132178f6d2875ea080021e0d1a80847b08fe052935"
    sha256 cellar: :any_skip_relocation, sonoma:         "a84e585d140a31deb4a74348db6ef72954c024b126715e075127a5547cfd0f77"
    sha256 cellar: :any_skip_relocation, ventura:        "8cf0c8a2f23acb0849333491b2a5b0507427933f317213b38bb196b9ce79c283"
    sha256 cellar: :any_skip_relocation, monterey:       "46eb85ce299da203e5c689234b91dbc20d53483e1c2a35042360ec9f33402062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4179aff98025129416df49507dc78b09b133248e85265f7f7d074487d9192208"
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

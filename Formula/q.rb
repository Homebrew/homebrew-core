class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/3.0.0.tar.gz"
  sha256 "edd3b3326c10bbb8d08ab2b820516c8cc4d461291de1bebd31f2ea65d3fa63b0"
  license "GPL-3.0-or-later"
  head "https://github.com/harelba/q.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3d4d40c7c4eacc8abe3ea9d3ab9e34ea0019d93b696a8660d092507c16bfa07"
    sha256 cellar: :any_skip_relocation, big_sur:       "df0790f33e2fc35de6454f038789eeeb51db774ff1c96f1fdf73da2291b13d64"
    sha256 cellar: :any_skip_relocation, catalina:      "df0790f33e2fc35de6454f038789eeeb51db774ff1c96f1fdf73da2291b13d64"
    sha256 cellar: :any_skip_relocation, mojave:        "df0790f33e2fc35de6454f038789eeeb51db774ff1c96f1fdf73da2291b13d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c5d5f054b1399bb5cdf22aab604873d00a11e5020ffd2427beec08da39fbb0"
  end

  depends_on "ronn" => :build
  depends_on "python@3.9"
  depends_on "six"

  def install
    # broken symlink, fixed in next version
    rm_f "bin/qtextasdata.py"
    virtualenv_install_with_resources
    system "ronn", "--roff", "--section=1", "doc/USAGE.markdown"
    man1.install "doc/USAGE.1" => "q.1"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end

class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.0.0",
      revision: "0d4cee0070587acf85a5e64fd60c60ea98f4035a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab10d83be0502992f66656dfb01e8f173ef84ef1b5e456e2467d9f92334da17c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac825e157064afb3ce94397cb95d553a32a6b6f59801f2fdbba29d48f483804d"
    sha256 cellar: :any_skip_relocation, monterey:       "5fa1106e3c95d0fef2e31aa684b21b4cf5ba6110937825980f4c555f3abb11c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "848726613a9ad25d57ba11a2cc60b18c3b4412725ff7eaa14e270ee61d6bb4f5"
    sha256 cellar: :any_skip_relocation, catalina:       "b9ce4a8a7ce08f5c856ee7d56aa60b978787bb8ef8dd5469d9484d51fa0ab601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f59d945825dbf8106c9cba45435f12b12231bee3a05014aee4f6d1585d0305e"
  end

  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end

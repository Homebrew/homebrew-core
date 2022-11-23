class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.1.0",
      revision: "01b9e5fa0a1e378185cdc38adb52155f5c4dc1db"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56e6093ab47302a9d3b23cde2662860e408988d0a1c37d64d7f40111ad152e9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f31e7ad8a9756e216ffa798d1eb3f72b6287696d0e141b84d68442883099bcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d6fba41606ec28108dff1ae620033ea698bcf8dbb838a7b3f49d175684dc8b8"
    sha256 cellar: :any_skip_relocation, ventura:        "587459333a35b5ad557c2adedf5cbd7d4317065e206edb1ebe9dc46549222ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "97a6828c35501ed73e8a4a46eb3e3e3b580e94453a32bf3ed0c9d449fb330e37"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d290178f607e07f603ea8a8d70db6d62eb313ab44e1f0b796dc527be3982a72"
    sha256 cellar: :any_skip_relocation, catalina:       "153f67ba5e9f0cbd76f5ea56a8ee296c9a2783dc0b0151e78f65ce10400b0007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ad4b6a38f6494c2f049231c87cf463a24a32ac5b6c417a847563b15765e55d0"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end

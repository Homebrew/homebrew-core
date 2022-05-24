class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.20.tar.gz"
  sha256 "46793aef623aac3700856c699cc04810b7a53533f829318729cee900c499a7e1"
  license "GPL-3.0-or-later"
  head "https://github.com/harelba/q.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72ca06a7c9dbe3b3eaee1b8db72811edbf7e64fbee5b694bcf2ed7e8d877d50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c72ca06a7c9dbe3b3eaee1b8db72811edbf7e64fbee5b694bcf2ed7e8d877d50"
    sha256 cellar: :any_skip_relocation, monterey:       "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, big_sur:        "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, catalina:       "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed14a331133ff96b85fa37e0729ca695bd273f78ee82e792185d137edf9917a"
  end

  deprecate! date: "2021-11-30", because: "requires PyOxidizer, which is a disallowed dependency in homebrew/core"

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

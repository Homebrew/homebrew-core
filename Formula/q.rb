class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.19.tar.gz"
  sha256 "cd4c60923bc40f53d974b54849f76096bf9901407c618cd0a3ccbc322aacc97d"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/harelba/q.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "959e08b1f6b453fa0088b5f02fc605c6c4ba270cad1f31231d7364c4e8b6d76d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f7a46b1e6d3709e1d4a39c5dc42b6c4024df2d4f4e70c565caf18af38f4583d"
    sha256 cellar: :any_skip_relocation, catalina:      "9f7a46b1e6d3709e1d4a39c5dc42b6c4024df2d4f4e70c565caf18af38f4583d"
    sha256 cellar: :any_skip_relocation, mojave:        "9f7a46b1e6d3709e1d4a39c5dc42b6c4024df2d4f4e70c565caf18af38f4583d"
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

class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.19.tar.gz"
  sha256 "cd4c60923bc40f53d974b54849f76096bf9901407c618cd0a3ccbc322aacc97d"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/harelba/q.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eed7070fddc3dda4f3c49cff16ad03d15687348e80b0a04882789300d16e2ae8"
    sha256 cellar: :any_skip_relocation, big_sur:       "de0170c2e58f55aa49b81958b53c6ba2a22876f64c7e5782d5760d42a9437822"
    sha256 cellar: :any_skip_relocation, catalina:      "c1ba50d0c4c47cddb88e3c2b1aa024b7c8f81810aa2c52c988e61d7115d1e708"
    sha256 cellar: :any_skip_relocation, mojave:        "6676084cffd70aec2c8bb073189df32ae0617d7e039d39e4b13a7d6cb7dc05ca"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a4976c08f89e618b70c73e96fd69bc8faebd193c4935a9d5b425012194c95af5"
  end

  depends_on "python@3.9"
  depends_on "six"

  def install
    # broken symlink, fixed in next version
    rm_f "bin/qtextasdata.py"

    virtualenv_install_with_resources
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end

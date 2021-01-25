class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.19.tar.gz"
  sha256 "cd4c60923bc40f53d974b54849f76096bf9901407c618cd0a3ccbc322aacc97d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/harelba/q.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de0170c2e58f55aa49b81958b53c6ba2a22876f64c7e5782d5760d42a9437822" => :big_sur
    sha256 "eed7070fddc3dda4f3c49cff16ad03d15687348e80b0a04882789300d16e2ae8" => :arm64_big_sur
    sha256 "c1ba50d0c4c47cddb88e3c2b1aa024b7c8f81810aa2c52c988e61d7115d1e708" => :catalina
    sha256 "6676084cffd70aec2c8bb073189df32ae0617d7e039d39e4b13a7d6cb7dc05ca" => :mojave
    sha256 "a4976c08f89e618b70c73e96fd69bc8faebd193c4935a9d5b425012194c95af5" => :high_sierra
  end

  depends_on "python@3.9"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

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

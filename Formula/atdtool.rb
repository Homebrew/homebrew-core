class Atdtool < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://files.pythonhosted.org/packages/83/d1/55150f2dd9afda92e2f0dcb697d6f555f8b1f578f1df4d685371e8b81089/atdtool-1.3.3.tar.gz"
  sha256 "a83f50e7705c65e7ba5bc339f1a0624151bba9f7cdec7fb1460bb23e9a02dab9"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "f046c7fce18236356a4e4ae42cdf6f06b338c411511973efd3ce883116fa6c37" => :catalina
    sha256 "70d3f21f1dc1ee76fa55fcb3d4cd5369300c8d361031267fb25f6426b13bdce9" => :mojave
    sha256 "2de45317e5c51f1fcb7365d038e667fcbf48f333af9c49eb0a27ddce2d2b1e57" => :high_sierra
    sha256 "2de45317e5c51f1fcb7365d038e667fcbf48f333af9c49eb0a27ddce2d2b1e57" => :sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end

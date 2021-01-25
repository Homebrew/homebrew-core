class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9bf13d30c902c1c5fbdcdfd07aa29e4d0a698eaf39342ad3d2cb017fe2fe514d" => :big_sur
    sha256 "6fd3c11c69283da1a7eea9160e5935a3ecb9b4e940d7522c7e10253bbbd8b93f" => :arm64_big_sur
    sha256 "c9749639795ac8d18278813fd8e8c62df76de23919cd58de6c65175539b7ec96" => :catalina
    sha256 "39dbb7e395b6dd34ca0e7ae1c723b586875551ab9a3cbff93b250a695ee25e64" => :mojave
    sha256 "4233cce0f722709b0d1b49c3af66faf3ea75ff5317a53d404dda2420ed147d75" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<~EOS
      column 1,column 2
      hello,world
    EOS
    markdown = <<~EOS.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}/csvtomd test.csv").strip
  end
end

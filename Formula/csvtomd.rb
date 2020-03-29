class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a095eb1747bdc18b737a5a1a090486cd0b694f33283163007f19b3b9e0abfade" => :catalina
    sha256 "87c756127704a0211c2dcb8d7e0b7b11dfbaf0a2878dfec9a4881e034f114fd0" => :mojave
    sha256 "c7ec7a2ff12f6d5707bb51b14bd078c2401840108cf1f6c4a774d04ffedf427b" => :high_sierra
  end

  depends_on "python@3.8"

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

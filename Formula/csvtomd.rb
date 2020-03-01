class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"

  bottle do
    cellar :any_skip_relocation
    sha256 "afbc8082fa52c379c904aba4ad436a492bf7568421add34fbceb3fb4cc72790b" => :catalina
    sha256 "be1e107cde89a22f8c1716b4cfa3e31b3009b6c7d5b79293e378e386dfbd2d80" => :mojave
    sha256 "70df513c26a7973a3475c3be18c332be4908374a747cec08e305c31656df01d6" => :high_sierra
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

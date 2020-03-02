class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"

  bottle do
    cellar :any_skip_relocation
    sha256 "918cd172ac8636b250cf346f0e5ea4569e9e9f2491607ff631bbe65036f70bb7" => :catalina
    sha256 "ae7121b0c78dbb3f52159995056a7eaf6c3707ea8b52baa9222fd3eace4cb7f4" => :mojave
    sha256 "d0d67820b26eec4a770e4b721298792c93dd1239ab78c4f972bf1d657954c852" => :high_sierra
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

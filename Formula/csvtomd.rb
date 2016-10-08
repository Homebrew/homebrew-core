class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/5a/d8/9dbce820243bb6db670cd1ddea80ea1890c6bfd5d122910fdd157d51d71f/csvtomd-0.1.1.tar.gz"
  sha256 "f2cd1da71ca8ed823d1f02167039e07e58d15a73d672069dfddcda8639576490"

  bottle do
    sha256 "4364ae91ea62c6b25d87245d0f9046bb3156191b1826ff337f717a43fe4c480d" => :sierra
    sha256 "ff9ed1382f01e5351c6377052e9e62618feeb04377294a5b7dc4c5f7b5a915c6" => :el_capitan
    sha256 "ae4316cbe060984c617344c9a581996b1456f3c7c4ad951097c7aa09bb331d97" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      column 1,column 2
      hello,world
    EOS
    markdown = <<-EOS.undent.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}/csvtomd test.csv").strip
  end
end

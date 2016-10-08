class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/5a/d8/9dbce820243bb6db670cd1ddea80ea1890c6bfd5d122910fdd157d51d71f/csvtomd-0.1.1.tar.gz"
  sha256 "f2cd1da71ca8ed823d1f02167039e07e58d15a73d672069dfddcda8639576490"

  depends_on :python3

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    csv = testpath/"test.csv"
    md = testpath/"test.md"
    csv.write <<-EOS.undent
      column 1,column 2
      hello,world
    EOS
    md.write <<-EOS.undent
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal md.read.strip, shell_output("#{bin}/csvtomd #{csv}").strip
  end
end

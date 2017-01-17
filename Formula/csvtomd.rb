class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/5a/d8/9dbce820243bb6db670cd1ddea80ea1890c6bfd5d122910fdd157d51d71f/csvtomd-0.1.1.tar.gz"
  sha256 "f2cd1da71ca8ed823d1f02167039e07e58d15a73d672069dfddcda8639576490"
  revision 1

  bottle do
    sha256 "c60454f44269f525807b10b67858b4f49d0d7eca10b367c097f54412a7516809" => :sierra
    sha256 "faca755b29c143c22d8c62643833454c81a0522a687c7180cf11fc14e1277b75" => :el_capitan
    sha256 "14d9321aa652cef9a4dab8a1c1fc966d6955a68fda3f3b3f10d454bd2c8ad731" => :yosemite
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

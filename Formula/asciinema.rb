class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/a7/71/771c859795e02c71c187546f34f7535487b97425bc1dad1e5f6ad2651357/asciinema-2.0.2.tar.gz"
  sha256 "32f2c1a046564e030708e596f67e0405425d1eca9d5ec83cd917ef8da06bc423"
  license "GPL-3.0"
  revision 2
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ac59de631594cea60621b45d85214e39a90a0ba8ddf4eeec5cba34bd6145711" => :catalina
    sha256 "b395128b1d0825a1b0ab81c4238d0acf38f6edc2df2a1bcfcaf6658ba191900d" => :mojave
    sha256 "1a941e2c0594a7c0a07c66f02c411e121ed2b3e869f3f015c6e69cb4fd92daba" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end

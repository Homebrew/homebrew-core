class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/a7/71/771c859795e02c71c187546f34f7535487b97425bc1dad1e5f6ad2651357/asciinema-2.0.2.tar.gz"
  sha256 "32f2c1a046564e030708e596f67e0405425d1eca9d5ec83cd917ef8da06bc423"
  revision 2
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcfe6fcf14def6bb9881182d67f94c91afdb0455e880aa743153269af7c77eaa" => :catalina
    sha256 "1ecae96f0952d1ea2156f779c86e09986744249ad5903db5f6da12664a8b5b99" => :mojave
    sha256 "d279386736b319c8cc83800303f0b3948b2e28bae92279479b69d70ed6c762b6" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end

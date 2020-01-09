class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/a7/71/771c859795e02c71c187546f34f7535487b97425bc1dad1e5f6ad2651357/asciinema-2.0.2.tar.gz"
  sha256 "32f2c1a046564e030708e596f67e0405425d1eca9d5ec83cd917ef8da06bc423"
  revision 1
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7567533cadf48707d06bc0b02b3020d2b4fb951abc7875f90ec4a63be484cbd" => :catalina
    sha256 "0181fd73b18e9ce96149b5751f12dd15ac7fd7e6c03405cbf7f99ae5b64b6419" => :mojave
    sha256 "29bd540035a1382c6a92e6fb8d47ca909694867c543a456b3f45c5a1ee319aec" => :high_sierra
    sha256 "29bd540035a1382c6a92e6fb8d47ca909694867c543a456b3f45c5a1ee319aec" => :sierra
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

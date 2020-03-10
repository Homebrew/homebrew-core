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
    sha256 "5422076ad38dc1ebeb2b70dc3312a329e0f4e72dd747cdd134d8df25c669b98e" => :catalina
    sha256 "326c68e10e65f73d1dcd0134ae912e075c7475422b04b90d714a6ee513ceae91" => :mojave
    sha256 "d665c2d995562ef9c7aadbec4707d567851ba8d46df5e7ae02b23be9cc26c0c3" => :high_sierra
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

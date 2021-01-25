class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/a7/71/771c859795e02c71c187546f34f7535487b97425bc1dad1e5f6ad2651357/asciinema-2.0.2.tar.gz"
  sha256 "32f2c1a046564e030708e596f67e0405425d1eca9d5ec83cd917ef8da06bc423"
  license "GPL-3.0"
  revision 3
  head "https://github.com/asciinema/asciinema.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0a5101fb3da7411764b53fb8dc6b8ab8a7c4a54ced892f9c832301ecbb9964a0" => :big_sur
    sha256 "b681c70de003112e00b3c31555e06453e0d22483095713fd27cfe9113e5363c6" => :arm64_big_sur
    sha256 "caa76523c644cf5916cde300c407d89282509a0291cfa9c4812d888c26ce7f77" => :catalina
    sha256 "b1a1aff9cf3f46328f0df80773a85898db70453fff4785e26e7ee4d6f12ef408" => :mojave
    sha256 "4ce78d8edeeb635ad7cf2f5edd88770baaa72d623ecc471fb0e8f5e12efb0e04" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end

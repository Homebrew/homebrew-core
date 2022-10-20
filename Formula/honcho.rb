class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/0e/7c/c0aa47711b5ada100273cbe190b33cc12297065ce559989699fd6c1ec0cb/honcho-1.1.0.tar.gz"
  sha256 "c5eca0bded4bef6697a23aec0422fd4f6508ea3581979a3485fc4b89357eb2a9"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef2edcfde1a8c8409c2d0b33a27bf5f223d5d2932ef7824dfa1cbb6e8d4ead8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef2edcfde1a8c8409c2d0b33a27bf5f223d5d2932ef7824dfa1cbb6e8d4ead8a"
    sha256 cellar: :any_skip_relocation, monterey:       "bfc07f9982c7c909af7c40963280933cb47afe7c9ba83b9598832b1c25d8a3d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfc07f9982c7c909af7c40963280933cb47afe7c9ba83b9598832b1c25d8a3d3"
    sha256 cellar: :any_skip_relocation, catalina:       "bfc07f9982c7c909af7c40963280933cb47afe7c9ba83b9598832b1c25d8a3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "502f8069959faf73d1d03318b681f89bf2dfe987139fd8b4913f52eb66b1d738"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match(/talk\.\d+ \| hi/, shell_output("#{bin}/honcho start"))
  end
end

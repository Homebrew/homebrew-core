class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/0e/7c/c0aa47711b5ada100273cbe190b33cc12297065ce559989699fd6c1ec0cb/honcho-1.1.0.tar.gz"
  sha256 "c5eca0bded4bef6697a23aec0422fd4f6508ea3581979a3485fc4b89357eb2a9"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3dada63778e9ed2ba5ea8afb8a0946f886f378539b5ee07164016026452a4ecf"
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

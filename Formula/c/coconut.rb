class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/b0/ab/0d6b1a95bc554d35763451f17315d61c763fb4316bdc9a47129353b90e65/coconut-3.0.3.tar.gz"
  sha256 "700309695ee247947a3b9b451603dcc36a244d307d04be1841a87afb145810b5"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db52e0d6a5e2524009b7ce23bf62f453dc0dbbc2d1e833f7b91fdc1ec1c7ed87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d150da03dbbdc798128a5e49905990401805e793f74dbc44674f6d8b1250824"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3978aab75be877dc206a76c73f2254f587101cccf00c82e36b2c8b74d21aed2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "259eabc26d6adc8d1078c997ac22a326ec7c490c28c650894e4ddf16024c4d9e"
    sha256 cellar: :any_skip_relocation, ventura:        "1fe79f37a88688b5e04da41e2f9cb06dc281eccb85b7eac10cf1b551e0336a27"
    sha256 cellar: :any_skip_relocation, monterey:       "14238493fd40f764bb5a3bb1f87aac37b06cd439e78c727f62291edf1fca28c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e343e2c13525b1fe786db1f33d24098cc80145fb523d7ef7ed2de47b3c661abe"
  end

  depends_on "pygments"
  depends_on "python-psutil"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/9c/6a/4134baf6f516d7c65dddd9bfbe745f3563b25887dfb61185b5fbaa51e18c/cPyparsing-2.4.7.2.2.3.tar.gz"
    sha256 "ac3ad40759709ee88c30ae3ff1c0c172ad22cf44a716cb2fcedbfed8986e7437"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end

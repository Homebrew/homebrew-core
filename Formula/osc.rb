class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.0.0.tar.gz"
  sha256 "7de363267803cbfdec4794da9da4491b18cd8b26dd94d6ab2071b80a24c14974"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "93144cf2161710eeee9aa2b5cf676c50e318e59231514e457144c96eb41d87d0"
    sha256 cellar: :any,                 arm64_monterey: "a83119ef9487123848841600f40ca303748c6a43362e078b874b44bbb15f3c51"
    sha256 cellar: :any,                 arm64_big_sur:  "af95c49efddcd1b3ba387e91217142cf4c768bc643ada25367aa688d22c096dd"
    sha256 cellar: :any,                 ventura:        "d1749b2dc0164cdfcf5b3cb87145ad9a9c1015fa87565363104c3f9db1e4428a"
    sha256 cellar: :any,                 monterey:       "51d26b7ba92aca0563e9a89650b5e76796dc5fbec1bcbedd726d32f02ca65b14"
    sha256 cellar: :any,                 big_sur:        "28074a56f1b8dc3d81031cbec687e95be2ca122efd7d749de4f5c179f3868a64"
    sha256 cellar: :any,                 catalina:       "b95acc4edb4e58a810dd7767acb69ad7f97b622aed911a682b8b9728ea6313f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5d40cb379b04526e1b974bf1c727a5b74f8bdacc9e568950f249e075fcece4"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end

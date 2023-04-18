class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.1.1.tar.gz"
  sha256 "05cb090487dc099f5cdfe4327cfd4d7bbf532a0b6a380c3cf83b29923b763ea1"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b129e08e98aabda7c93c9952d14aa67d73785339681d9928b4822645b0b6b2f"
    sha256 cellar: :any,                 arm64_monterey: "d74863de809292501ebbf46c1ccc20ae787a58bdbfe43ef0f4b4ccdd9cbf4192"
    sha256 cellar: :any,                 arm64_big_sur:  "e0876596a6e7ea778e729381d7e5f162a0a384b31e388c6a0299d32a3bc1cb40"
    sha256 cellar: :any,                 ventura:        "1c1f3f6ff2b8e71f9b0b5570de427629b2c492e7132b31b8ebc6fd8663ed8d26"
    sha256 cellar: :any,                 monterey:       "bbad5dd20ad775996f8934ace887db652c8e8e1a4f6b35190160d694e68464a2"
    sha256 cellar: :any,                 big_sur:        "a42aeb351f445f90ceb6708f20eb172df832a75fd76061abf0d3800a8cb7249d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa69d08c35fb58783e85f5043a541c07712920606c23ab36651101fd58595b8"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/15/d9/c679e9eda76bfc0d60c9d7a4084ca52d0631d9f24ef04f818012f6d1282e/cryptography-40.0.1.tar.gz"
    sha256 "2803f2f8b1e95f614419926c7e6f55d828afc614ca5ed61543877ae668cc3472"
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
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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

class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.1.4.tar.gz"
  sha256 "8407ccdcaa6089601e3b9f42c03c015d938ba756b1553f65e2eb122ff00b83e5"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a29dcae921021ebf9ca73382c82ab3e96d9bdb5ffac01c1aa22c791f7857871c"
    sha256 cellar: :any,                 arm64_monterey: "034d31db53d2019a38bfff6731335e0fbab6faa37f0b1080d29dbda8a0e27ad8"
    sha256 cellar: :any,                 arm64_big_sur:  "45ab47113b9a0f4a109ca20d2d98712eeb10baec2e16dfc460391df7e654b8ca"
    sha256 cellar: :any,                 ventura:        "91129a29427f6369753195ea08c28ab1ff7a9c70e1482cf9794a81cb2511b054"
    sha256 cellar: :any,                 monterey:       "07e5b8bb2faa604502cb536bfacbda1de79f34f978a6ba6e8d6a3c5616658c60"
    sha256 cellar: :any,                 big_sur:        "81d59e925f84e1becb59fb220f21a62adf4d9c11dbb4cefc4d8cb77ac213216c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd06377a65518600dc3d97468c1405134d08adecfe68ce083b3011bc713609b9"
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
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
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

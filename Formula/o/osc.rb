class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.4.0.tar.gz"
  sha256 "bc083473d5677ba75e2b9adf867c32fc17bb11adc38d863cf9c7a2d8c1d01287"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d882b017ab67c6b48406592474634a864733758c063505055bde44f96f5d93a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adc105a87f219e8e7142950c19860a009520347fd2c694795cb0863775be4b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f46812a1f97e48013cb311cff9ea54a92020c9e8cef2ada8865f3c85b0ac544"
    sha256 cellar: :any_skip_relocation, sonoma:         "883ab3dc854782884e4fe02e896db8be444cb3b9e7dc17d7a7ac80a6a661e55d"
    sha256 cellar: :any_skip_relocation, ventura:        "affa1c92df934838b3b1472b2a47573104b916edc3741a56a96dfe26b481801f"
    sha256 cellar: :any_skip_relocation, monterey:       "601007eedeb2136b459924ba55151c4b7a40ed2beff944b951eda7c6687b49ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd35c3de2718bf85aa742666bc5b9eafbb7cf1803286ffaefd863c039967185"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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

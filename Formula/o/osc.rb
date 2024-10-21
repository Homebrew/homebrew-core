class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.9.2.tar.gz"
  sha256 "c32bcf47c8a0f23a722fca781959ef2b1f865d0d4ed32be237f3e4444e671864"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1f568428057edf8e1f160d9c5d82f32bbdb11fd604d6b595c6eec92e9f3177b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f568428057edf8e1f160d9c5d82f32bbdb11fd604d6b595c6eec92e9f3177b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1f568428057edf8e1f160d9c5d82f32bbdb11fd604d6b595c6eec92e9f3177b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b13d67cd299b39bccb518ddd249031e6337149d1c173960a971e2ac071796922"
    sha256 cellar: :any_skip_relocation, ventura:       "b13d67cd299b39bccb518ddd249031e6337149d1c173960a971e2ac071796922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f568428057edf8e1f160d9c5d82f32bbdb11fd604d6b595c6eec92e9f3177b"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/44/1b/ef44b5e2fae8e398bfc58f38c25a6f0a10ea147e3e4970b7e66154017d1d/rpm-0.2.0.tar.gz"
    sha256 "b92285f65c9ddf77678cb3e51aa67827426408fac34cdd8d537d8c14e3eaffbf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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

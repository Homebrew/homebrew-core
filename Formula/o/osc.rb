class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.18.0.tar.gz"
  sha256 "adc29cfc399ba6c9f2b424483abd395a1173a07f8ff5cf1926e7447b2a89799b"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f45147162512da2f93cc5a4812ef1cda22071ba27189e7bc6f8d8db1ae2099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4540fa3d18982714072840951aaed38527b2b75f3a5d11106fe0255427b2fde7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bf88835fd712e2415a353effb9fc0cac104d7f2977113c737229fe0a2206322"
    sha256 cellar: :any_skip_relocation, sonoma:        "317b5ef2113979f15acdf4eddc953e43bc8ef65d29fd76b4a87bf3f0daa87ea5"
    sha256 cellar: :any_skip_relocation, ventura:       "122612aefdb1b32b5a6c9fd87836d3d79e1c2e5cf986317229a48af8fffa0afe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cebbd258d9b11b9c228ef311e098689d9b0c683dd55b84031a2b38594205a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f886a5d7efc6094ff985f64b0dc9f9d7a9913c5afe8d99827fd693439684712"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/bd/ce/8db44d2b8fd6713a59e391d12b6816854b7bee8121ae7370c2d565de4265/rpm-0.4.0.tar.gz"
    sha256 "79adbefa82318e2625d6e4fa16666cf88543498a1f2c10dc3879165d1dc3ecee"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/87/6da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547/ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~INI
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    INI

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end

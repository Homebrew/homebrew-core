class Offlineimap < Formula
  include Language::Python::Virtualenv

  desc "Synchronizes emails between two repositories"
  homepage "https://github.com/OfflineIMAP/offlineimap3"
  url "https://github.com/OfflineIMAP/offlineimap3/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "5d40c163ca2fbf89658116e29f8fa75050d0c34c29619019eee1a84c90fcab32"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/OfflineIMAP/offlineimap3.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9e0a8ff12072770f975f828a2fea704819b9a6fecdfa9de79f9f2fa1c59451a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02e3c8302de0a92ac8643a4f7f180d73fe21b5db94f5ec6c139e8478735441e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33da7d64fb20940b09c44a0f2a8e60e9a54c5a20b852bce8ca3268c6794c69f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "edc182248abc20d351a300d95a23cb4fce84fb69dda668d96d37e16b3906dc2f"
    sha256 cellar: :any_skip_relocation, ventura:        "d3edfbf51853ede464760a7190510391aca69562e898768bff75e09b80b76515"
    sha256 cellar: :any_skip_relocation, monterey:       "aecc142181b4bd7fac320fea4ca6f8b7500dbf908b0314f3066b939115193462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17807b22a5818a6d03c8429eb1cc32a9fca98938e3bc8741a482c7dda351329e"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "krb5"

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "gssapi" do
    url "https://files.pythonhosted.org/packages/27/71/5110b5af9354e5eb66a30dbaa6bac2a5e3013057120544830a849dbd087b/gssapi-1.8.2.tar.gz"
    sha256 "b78e0a021cc91158660e4c5cc9263e07c719346c35a9c0f66725e914b235c89a"
  end

  resource "imaplib2" do
    url "https://files.pythonhosted.org/packages/e4/1a/4ccb857f4832d2836a8c996f18fa7bcad19bfdf1a375dfa12e29dbe0e44a/imaplib2-3.6.tar.gz"
    sha256 "96cb485b31868a242cb98d5c5dc67b39b22a6359f30316de536060488e581e5b"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/a6/5c/57ef8091f9f1d01bf5413fcd0fd1f2f255f45536e42bfd34bc45b6cc2786/portalocker-2.6.0.tar.gz"
    sha256 "964f6830fb42a74b5d32bce99ed37d8308c1d7d44ddf18f3dd89f4680de97b39"
  end

  resource "rfc6555" do
    url "https://files.pythonhosted.org/packages/f6/4b/24f953c3682c134e4d0f83c7be5ede44c6c653f7d2c0b06ebb3b117f005a/rfc6555-0.1.0.tar.gz"
    sha256 "123905b8f68e2bec0c15f321998a262b27e2eaadea29a28bd270021ada411b67"
  end

  # Support python 3.12
  patch do
    url "https://github.com/OfflineIMAP/offlineimap3/commit/b0c75495db9e1b2b2879e7b0500a885df937bc66.patch?full_index=1"
    sha256 "6f22557b8d3bfabc9923e76ade72ac1d671c313b751980493f7f05619f57a8f9"
  end

  patch do
    url "https://github.com/OfflineIMAP/offlineimap3/commit/a1951559299b297492b8454850fcfe6eb9822a38.patch?full_index=1"
    sha256 "64065e061d5efb1a416d43e9f6b776732d9b3b358ffcedafee76ca75abd782da"
  end

  patch do
    url "https://github.com/OfflineIMAP/offlineimap3/commit/4601f50d98cffcb182fddb04f8a78c795004bc73.patch?full_index=1"
    sha256 "a38595f54fa70d3cdb44aec2f858c256265421171a8ec331a34cbe6041072954"
  end

  def install
    virtualenv_install_with_resources

    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
  end

  def caveats
    <<~EOS
      To get started, copy one of these configurations to ~/.offlineimaprc:
      * minimal configuration:
          cp -n #{etc}/offlineimap.conf.minimal ~/.offlineimaprc

      * advanced configuration:
          cp -n #{etc}/offlineimap.conf ~/.offlineimaprc
    EOS
  end

  service do
    run [opt_bin/"offlineimap", "-q", "-u", "basic"]
    run_type :interval
    interval 300
    environment_variables PATH: std_service_path_env
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system bin/"offlineimap", "--version"
  end
end

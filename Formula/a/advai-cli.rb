class AdvaiCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for managing skills and external CLIs"
  homepage "https://github.com/Advai-X/advai-cli"
  url "https://files.pythonhosted.org/packages/ca/2c/4e7e64f2c6895555a5cf6cc4b7fd030d1b265f77969d1f417cfd84bd802e/advai_cli-1.0.12.tar.gz"
  sha256 "d3e9921e3a878df3f604a85fc62901b9aebbcfbff36beafe2b50f18ea6a7617c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09bd214364abd8b78b5b5f6bfb32f210396743af575cc8538c3e6a3c25058d0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d68d525c046269354896e580302f8d1e2e85cfb7d13230eeef890ec04f8f4d46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a9bea682f0d46ea4f774c8fc7adc0e1770c00121be46dd02e16450fd831f3e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "610251d6f89e6e3be4b1aabb9cd8f7063328cd328311b0f4db389c866a656ac6"
    sha256 cellar: :any,                 arm64_linux:   "18089b30937572ff539f49e2d9bacd5ae1b1542dd3bf3827041c10af9a8a87a1"
    sha256 cellar: :any,                 x86_64_linux:  "3afe599ee17e7ff8fef042f3c9d6b79fac54a0e591023eecf27e58dd06d7091d"
  end

  depends_on "python@3.14"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/1d/cc/58f26f118d8099f84e009ce560b9148a3f803e63fa8473b57feb67241875/aiohttp-3.14.2.tar.gz"
    sha256 "f96821eb2ae2f12b0dfa799eafbf221f5621a9220b457b4744a269a63a5f3a6c"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/31/33/ebe9e3d1f86c7a0b51094c0a146392045ca1631d2664889539dec8088a33/yarl-1.24.5.tar.gz"
    sha256 "e81b83143bee16329c23db3c1b2d82b29892fcbcb849186d2f6e98a5abe9a57f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"home").mkpath
    ENV["HOME"] = testpath/"home"

    assert_match version.to_s, shell_output("#{bin}/advai --version")
    assert_match "advai:", shell_output("#{bin}/advai info")
    assert_match "(no Skills installed)", shell_output("#{bin}/advai skill list")
    system bin/"advai", "kb", "create", "ci-kb"
    assert_path_exists testpath/"home"/".advai"/"kbs"/"ci-kb"
  end
end

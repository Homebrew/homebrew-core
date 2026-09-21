class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/d7/10/d38552dc28cf53c28b3a07bdd4936ea78a65a420c969e8caa60b52b66cae/dxpy-0.414.0.tar.gz"
  sha256 "0f8c502a0087d91c4f616dcbfffdc5116ea4b7699e7297b5cb152540f63266b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6e8dc76dd7371602f1c339782075068f83425a8981482f8e82f37b33870af627"
    sha256 cellar: :any, arm64_tahoe:       "926550b5f46d1686bd90c27f9ff6b8d07c3a70b56473d28a8b660aa319f3a5f6"
    sha256 cellar: :any, arm64_sequoia:     "5dfd53326a18fcb3179505a160543bf17e747f907685352486098f21268d84df"
    sha256 cellar: :any, arm64_linux:       "29f5b743766f1bb5e0cde555136e2a25554be5d089fe60725d4eb3faac4ea771"
    sha256 cellar: :any, x86_64_linux:      "a38feac534b9be02ee4bc34b605b0c210547c2e450fef3aeed658f7d542d1f73"
  end

  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-checksums"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"
  depends_on "s2n"

  on_macos do
    depends_on "aws-c-compression"
    depends_on "aws-c-sdkutils"
    depends_on "openssl@3"
  end

  conflicts_with "deno", because: "both install `dx` binaries"

  pypi_packages exclude_packages: %w[cryptography certifi websocket-client]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/5a/bd/c2f26ee1e70b263f9a8c798749e0ec0b5a599c1dc46fe5648a6d6ebd9b44/awscrt-0.36.3.tar.gz"
    sha256 "d3e97196dcf152232e0a8df9eb5a41dec4b3a3315794179116f1ace4b331c750"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/f6/07/b5fabe88654f5eded3e4b6d84cde572dd0280a7362a6a5b698bbd77be5df/crc32c-2.9.post0.tar.gz"
    sha256 "6a089e0340de8438e836a09e613c6b541675d0f3aa92b3fe34295aaba62f014f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  # Issue ref: https://github.com/dnanexus/dx-toolkit/pull/1530
  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"

    livecheck do
      skip "Skip until new release with v1.9.0+"
    end
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"

    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end

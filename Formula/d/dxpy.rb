class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/d4/c1/2074d1d29a58a056860aff931e4bb06f0fbd960ec0d1ff4d13a8447afba8/dxpy-0.418.0.tar.gz"
  sha256 "325f72008804d22d04dc38ef085495c55d3ad7dd367bf7bd5e342f649644c996"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d60d181e9387eef2a20bd3bf58ee4af918ba7adc49d57a6a4b37586f79d6d310"
    sha256 cellar: :any, arm64_tahoe:       "9b40831dd09fde6eb7be61c0233c9d05d57c6c0670cdcf6ff3abe4c0361accce"
    sha256 cellar: :any, arm64_sequoia:     "2baad404b466266d635fae2e2790a0ea17a52ded72a4e4069f2a82ba29d6db08"
    sha256 cellar: :any, arm64_linux:       "fde9e3a5beeba95bd7f44d33fae2cebaead944e6f35535e7ed7345ed6dfc05ab"
    sha256 cellar: :any, x86_64_linux:      "c7bf9653380fa6c8318759f9845cb97de50464638dfa0c0fc2756ed94b681233"
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
  depends_on "python@3.15"

  conflicts_with "deno", because: "both install `dx` binaries"

  pypi_packages exclude_packages: %w[cryptography certifi websocket-client]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/bb/02/2a724318c05aa0e6e74e2537e3a841097ad2aeb737bdc27c6a74ce72358f/awscrt-0.36.4.tar.gz"
    sha256 "5b6a53f10e8dd060e7c0c91d063831137239c234877a6d1f03b277dfbac0c507"
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
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"

    # Backport fix for OpenSSL 4 until dxpy updates urllib3 pin to allow 2.8.0
    patch do
      url "https://github.com/urllib3/urllib3/commit/627636551e0e0159996b0f28dd21a60372cc5b10.patch?full_index=1"
      sha256 "6e5f13b1b60313fbd8a70d0aab58f7c6a413f641ad6fa2e5a3539e3de68bbe27"
      type :backport
    end
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
    urllib3 = resource("urllib3")
    odie "Remove urllib3 check as version is now >= 2.8.0!" if urllib3.version >= "2.8.0"
    odie "Restore urllib3 patch!" if urllib3.patches.empty?

    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"
    # Avoid overlinking to aws-c-* indirect dependencies
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

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

class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/fc/e9/81301d5635d1b4e54d3ad140dba5ed56609615ee8f709a59d8ba0123b5de/dxpy-0.420.0.tar.gz"
  sha256 "59472289a6a114b021c1354285fe56620f1dc4ab657ba436b343482fdebab748"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "7fd6ba14564f9bad5fd7308be12ab41be55b9c383a77727f4cf643cc7beab8bf"
    sha256 cellar: :any, arm64_golden_gate: "c15f56307934ed57997a9675f00bbc1741dff68971d3ca759d1751b8caf2c21f"
    sha256 cellar: :any, arm64_tahoe:       "f9e1815ebefa3a8a9938dc0ccaa299acbcd74f89c570b253b3e65962ad9811f8"
    sha256 cellar: :any, arm64_sequoia:     "01562713a33a971b7ecf9493de63ad21f9521df3e54f26dadd6b312f6b434275"
    sha256 cellar: :any, arm64_linux:       "388650134e22b572268509b6c6e6bf1256473cff65fc466c36ea6a1ed37915ea"
    sha256 cellar: :any, x86_64_linux:      "0f3aa6975cb6bd2c8e24e2374164174e45c6bd3be4ea18a451b76bde37b7a074"
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
    url "https://files.pythonhosted.org/packages/19/0d/ca63f1b8b706c70590d0a4acc9c3c94ea8ed4dd9c83b4f7af195868abe76/argcomplete-3.8.0.tar.gz"
    sha256 "0114d634013e11ac92cc329b3a7d886c3506e98ddc7bb23c99b1782aacc8b8bd"
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

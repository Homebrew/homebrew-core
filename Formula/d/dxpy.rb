class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/2e/3b/481347ef444726c9dc6ad6e4b4b2faee795dae89b132a4e9daeb1865abd8/dxpy-0.419.0.tar.gz"
  sha256 "977bd62ee56bebc9fbd875243613e42229742535f03876c1cbb048aaf4a5d673"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5d1de8a78534e4ed0593b193dccae3ab151da6b8b5c196b29175bc8442e0830e"
    sha256 cellar: :any, arm64_tahoe:       "4f4f43ad4604f91a2d3d293bef975a4a182c3efd85a1835aab075641d9bf6c83"
    sha256 cellar: :any, arm64_sequoia:     "03193b9ece195fa3954983b3360a4fa3e7d39643c6823ea622e21d03232edf28"
    sha256 cellar: :any, arm64_linux:       "2f4e95cb97058814f593c26ec31a61face570d1c41d1851f7028400bded4cd60"
    sha256 cellar: :any, x86_64_linux:      "fef14e730862410026d0f5be074d322aedd9e10ef41c74ab067fddb6ddccbaaf"
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

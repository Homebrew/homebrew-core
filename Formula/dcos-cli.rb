class DcosCli < Formula
  desc "Command-line interface for managing DC/OS clusters"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.2.0.tar.gz"
  sha256 "d75c4aae6571a7d3f5a2dad0331fe3adab05a79e2966c0715409d6a2be2c6105"
  license "Apache-2.0"
  head "https://github.com/dcos/dcos-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7c3e8a7a0d91d84fd13cad41079bd7d718928b1acbaede6f7c5fc0f419b1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f86f45ed4b5244b46a83cb5bf5bc5ac869dfbae3af926f175bee78a0ebd9b47a"
    sha256 cellar: :any_skip_relocation, monterey:       "26c6a023e4d2cf388c41f684d52f3d427f57d0a6eacd54a286c5f7c56efb7957"
    sha256 cellar: :any_skip_relocation, big_sur:        "1391a435f38b3a70514d0ef7f0a20f19a2d7027e64cad5c1b413730a89aaec4f"
    sha256 cellar: :any_skip_relocation, catalina:       "3f64db455d356a65dbb8be7bce2346b9b8afec968082bdad1efafb174bbde1b8"
    sha256 cellar: :any_skip_relocation, mojave:         "759770809a74366f84721771b18702a3d27c9e6aa9099f25895200462df17ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca96957a95df6e3084eeddf3d45cd52a26bdd69446647af7e52f297c6b1f1ce"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    ENV["NO_DOCKER"] = "1"
    ENV["VERSION"] = version.to_s
    kernel_name = OS.kernel_name.downcase

    system "make", kernel_name
    bin.install "build/#{kernel_name}/dcos"
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=#{version}", run_output
  end
end

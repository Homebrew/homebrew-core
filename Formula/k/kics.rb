class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.21.tar.gz"
  sha256 "c27b5caac95c30c7f57d639a23d44752ceb4c792ec7d9a4c6097a095750e5793"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c037ddf04d7564d96f53a95aaf7dced9579a2ba6a7fdb4bca8233953e7469cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7009fbb3be49c4cf3eb0ea545a3b27be8b8d5bcbc21f65c00ebb64980ac575f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33d6b60e64355a480c63cb50e73a798b97f713299de4dcb841d2660036d06477"
    sha256 cellar: :any_skip_relocation, sonoma:        "199a2f5522dd625e83b0fba7ee7cd359e546e293bb53e8ba85e18524a92a40f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2670a2c5e18b5ad8655a53f9adefb4a293e5c2fdbd187348b9f28a57fbe4ae33"
    sha256 cellar: :any,                 x86_64_linux:  "d11ec44b591f2b828c9f5244f9b392ff7d3fd22be53df62aa3d3a0c9d9aef340"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"
    ENV["NO_COLOR"] = "1"

    assert_match <<~EOS, shell_output("#{bin}/kics scan -p #{testpath}")
      Results Summary:
      CRITICAL: 0
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end

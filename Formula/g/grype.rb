class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "b0e38671975c0871f1b9a7bacba376f90ecb429973cb4b5b9cf90a3f4e072304"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "200df64b358cb6c425deae8b4f0766233ff6aa413e934c90e121f487195653fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c964a244f54ffeef5cb73f3901a6e1bb760136cf62ee088e9de7fafa4d68d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c008bf75d4dd46631cf534881de327c4d989a71e570840dfcd3b4098c7b385a"
    sha256 cellar: :any_skip_relocation, ventura:        "b15a036de225749cc72b0da70022ccee9afd5701b4ea92a7ed2586ed326201dc"
    sha256 cellar: :any_skip_relocation, monterey:       "c518b0162c82931871a33ebc4935426fd915d7bfedcf1cc5d707f4d8cbd09a91"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b21de7a879f3a13e9c69eb9cacb5b25125e9ee158c3c8afe15aab9bac3e5b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9416713a6abc10754e2f492ec7787ec549e3eb3d71e8500282e7d6d980079896"
  end

  # upstream bug report for building with go1.21, https://github.com/anchore/syft/issues/2066
  depends_on "go@1.20" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=brew
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check")
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end

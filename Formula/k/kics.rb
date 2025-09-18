class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.13.tar.gz"
  sha256 "f3d775755d8ca0de8dfc7bef23aa11e46a5e269c438f8f732a30805ca9eba08f"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72c1824190f2c95d94d226f522f98bf9ce7708ea8a6c9036c1782bf15ae84431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663eda4c71fd2ab9581182df73f96b5bc0d27b0a67a82a7fa655838abadb91a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7379edf169fe527ba7a2fb317c879d022306c6778bfd16b71f3e11d734566b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d24eec0fccfa2af92d40c5550293b24b93631caa3245f8e0b28b321156a7a17f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93243cece012562e2d7960401781e86c15ce9d731d766a4fe21abe4a5b6e376c"
    sha256 cellar: :any_skip_relocation, ventura:       "f3f29c260cce9d30bffb46af11f7cca574bcde715993d2642cc9c92bc49400c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ba822758f831434584dbcd1273ded5b3bf245e1289cade6f29e5ccaec624c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f5eefb7d7f95be9028822830c892a3cc2c4dd21ebb6641386895ea06869c011"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
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

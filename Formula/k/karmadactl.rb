class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "beba11cef484b2a5ea72bb3fe193b0ff9b2caa9afca5f491dcadbd7221cedc1f"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7625e68ac7cd8a18d70d6869ae388498bf0a09b5f46752b66735170ffcf10a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9228c8a12be8582031e3285b693750e8c0bb4c0eab8d8746839be666ef32b1a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b1c7d129ecc5ff80786340b1893e574cbb3fdc79cfd4f62f51d965123819b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "80fe009c5445354dbc45ae851c425ff3e7f536abb156ae281929c42f68db36e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb18ba29b4485ad0a6b9154ae8bb92bbf884b615f77918387e3144ebc7892db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ded992d51202360c7bca853eba9646612a75ea7b09f2cc3e79de92b94b2f5ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end

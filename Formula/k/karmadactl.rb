class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "773420c4bef1a78605703a6dc65d48e552cdd1be47cd0e436f6e7a3b3a1b54f0"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3909e74400a08fa689e0e1e6513804fbecdc7d14123ff4893327ac58d9d134f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9315978ed9ca864f68099d05cc70c1be5b00f97bd4e54384fbab34d1166483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37994c14a964aa667d3e1515a9f5bc40f691aecd5e4eab53b351d1d2b92892c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6773d6cf67398eb7ec7cc82849adf0f4f6d419edfb6c22fda46de63423db825c"
    sha256 cellar: :any_skip_relocation, sonoma:        "893317f6a63f53587c846e05b7b9ba95329773cd2e7fb0099655043448c071ed"
    sha256 cellar: :any_skip_relocation, ventura:       "751529e2f7ca92eb9fcff467acaf23216175213fb0e3cd8bc3c6096ebcc4cedc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b7f2b4c084d841039d3d54568ed3bee69bf3c7cf29ed4c5e41cb822b8b1aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667c0038140867dbe295bce5fc389322816d71a7b9ad0ee5020e75a17e52daf6"
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

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end

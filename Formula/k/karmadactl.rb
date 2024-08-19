class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "64a72db838d8f3e3243815435bea54ecd929edd1e90430537d0d28508997a219"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd851526b18631ba72fc73fd55b36f27aff6d5af1af1dd6c91dfb0f5b3977785"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e04fc572d51ff2a25e0beb8b3285941d4f27ae7676f94eae34702f28768074be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa9716058278ade7b8b7c6a89486afb851687f514f97b4ba72c2c8984f137f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7d2ec7d412432a2a015b7c951feddc5bdba29983a645c123460fcf36c728e0c"
    sha256 cellar: :any_skip_relocation, ventura:        "96ae5c5f9363bcbadd211b31b004dec2c39e273b0d83fe7bc48945c734677685"
    sha256 cellar: :any_skip_relocation, monterey:       "14e964a3cc1d6a57505f3dbe30e573a3f2544ab2c799b28a0a41c6286e719513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d8d46f6d555a06f193e218da22edf63345eccd56b1054d6781dec760a94dd5"
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

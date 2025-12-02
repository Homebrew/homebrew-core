class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "61c0e81f91e5b638775b22e0e324fcb974a36b136008ceb841a3398ef04b79a4"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0e8152187d3b3f1f86f7ed7326829d784b955add62adc7f95fc5f45b2aa486d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e715bc2a976e294f0c7cde2ff59d573f6f27aedaaa8bc43125067ccf6762e35e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05d69b443a09e98e708984d04d10f9ba7b0039a3af703fa72c39dbcb789ec154"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e120de4c123df4d0b1eeb89f8f70ec0b3367aa0946715baaf4a7a150d7a551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fec9bc29d79353fde9d6da458a19da2e0751fe59b33058d39e0c8568c08b708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9abe1236986000b3a74e23d8e9dbbb7f3d2bc446ca2b6e195590dcf29b23da3"
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

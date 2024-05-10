class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "d82402a9f8bfe560487f0a23ad744fdd1a6cff3026f2fd774dc5ee53f0996efd"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "594c5e2fe475f3be691e6c81f270cb62a9a9b00c8eda044e5e6cbcd1171ae1e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80bf69cc8329b75955f8c15aaafe67988b928791a4ca13d04a337e835482aa18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b90c4518877e708305577636d88ca93d138b959108981fdcfaf97453127ed3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b1084b7c4678a80dfb1c2e354d2acb72631326dfcdfb175c1ca9efc01b05823"
    sha256 cellar: :any_skip_relocation, ventura:        "f2315260375e74190524e947ee765adb123e2eadd6e5c0439689a312d63846e7"
    sha256 cellar: :any_skip_relocation, monterey:       "1986481067bc13afe498e9443d4834f0a9d9a16931f51c71d4c91a35b6548de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f63be66291547cb547a750327b5d159ad6881f053b84eb144d40177cf8e1b2"
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

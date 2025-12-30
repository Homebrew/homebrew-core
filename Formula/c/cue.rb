class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "e8c97c99b87bc4d479c41cce185294665ccc6706ccf2b528d6b3e1d68569a454"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82348ab8d29840757a9f0902169d3e3ae81eb88f5f7a66ef38bbc2d814cfc598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82348ab8d29840757a9f0902169d3e3ae81eb88f5f7a66ef38bbc2d814cfc598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82348ab8d29840757a9f0902169d3e3ae81eb88f5f7a66ef38bbc2d814cfc598"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26ff0d337ca5cacc8b134262f7d5af28ffb17bd63e62bd5987ec34a5a380e83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "665e16d25c97a6e35c922c1a0c658df78cd6036f705628460d235157eb69e5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa549da20619dc6e0a5cb693d015af323cbb2f346542e56edc91f18b6793956"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    generate_completions_from_executable(bin/"cue", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"ranges.yml").write <<~YAML
      min: 5
      max: 10
      ---
      min: 10
      max: 5
    YAML

    (testpath/"check.cue").write <<~CUE
      min?: *0 | number    // 0 if undefined
      max?: number & >min  // must be strictly greater than min if defined.
    CUE

    expected = <<~EOS
      max: invalid value 5 (out of bound >10):
          ./check.cue:2:16
          ./ranges.yml:5:6
    EOS

    assert_equal expected, shell_output("#{bin}/cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/cue version")
  end
end

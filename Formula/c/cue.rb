class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "dc94fffc76530cc0faf270c2eaee519ee1397dcd832845571f8ed0386ab3bec3"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62b33c2dc383c0baa3dceca83ba36453d37d63c9d6fce6e71cca498f7e714f5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee2bb3704a7a236433abe1df72f6299e315d13a09f07d8ad7b8498e9d4eb3ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2bb3704a7a236433abe1df72f6299e315d13a09f07d8ad7b8498e9d4eb3ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee2bb3704a7a236433abe1df72f6299e315d13a09f07d8ad7b8498e9d4eb3ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "555cbd7bd4995ca45a33feb4b0e411289edcb2856889685410a43e82a5cb413c"
    sha256 cellar: :any_skip_relocation, ventura:       "555cbd7bd4995ca45a33feb4b0e411289edcb2856889685410a43e82a5cb413c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4bdf1945756930a3d2f9f9ffe20664641da9fbfe18fd52c239b6903a6b9f317"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    generate_completions_from_executable(bin/"cue", "completion")
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

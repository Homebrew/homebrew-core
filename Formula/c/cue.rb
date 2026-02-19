class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "504712c95d8df3b8b4fbb207aed2a3fea49dbdcc5dcfa873a64ca00801d5ef73"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3aea9d4f47964ec289268edfa4ec62fc78592ec34694f412edb045bec5f2dcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3aea9d4f47964ec289268edfa4ec62fc78592ec34694f412edb045bec5f2dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3aea9d4f47964ec289268edfa4ec62fc78592ec34694f412edb045bec5f2dcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2fabbacd7ed27ce98d6d548bff0bbc489d72f28e34e51c8dbce421cb9ff6d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7787bd48932c7438a38858593fc5e0fe2fd834b084e9d6bdb96a9b401e700e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b011060d417edc72c471c7fb49aebd6260f67828a4cecf1742964b80713c8334"
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

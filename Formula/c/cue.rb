class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "361445d72b47216f85d1c91bf5db7a90ef7a3f3484c4b350c2964591493e68a7"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9159720cefe51a6e15c79ab16c0604689ee5efbb725d14afe7112bab8736d360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9159720cefe51a6e15c79ab16c0604689ee5efbb725d14afe7112bab8736d360"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9159720cefe51a6e15c79ab16c0604689ee5efbb725d14afe7112bab8736d360"
    sha256 cellar: :any_skip_relocation, sonoma:        "2736aab26a841bd541a6b9fd0907e56952ed6f16724aea2eeec66e06c7c4b877"
    sha256 cellar: :any_skip_relocation, ventura:       "2736aab26a841bd541a6b9fd0907e56952ed6f16724aea2eeec66e06c7c4b877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00c3ff18e17e8e80197f7b70830ca0fc9e79081a0d21d1b7157bef42599e198"
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

    assert_equal expected, shell_output(bin/"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"cue version")
  end
end

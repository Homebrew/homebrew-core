class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue.git",
      tag:      "v0.18.0",
      revision: "81b90d2963ed1d60b99306e45507fe6d73f37bb5"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    manifest_sha256 "d79cf916edee1597f67a57d20ebdd6fffc043991ffc4730a0e4c1044b839675f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8facc2a3230639c2421c62ba785e3f33e203c5f56fb168fde3347a936e38bd40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8facc2a3230639c2421c62ba785e3f33e203c5f56fb168fde3347a936e38bd40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8facc2a3230639c2421c62ba785e3f33e203c5f56fb168fde3347a936e38bd40"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32f1d3aee627df67f51507f680cc477c90d29f2f6244c92fac37265277e7373d"
    sha256 cellar: :any,                 x86_64_linux:      "c55e4fd107f88acca784d5cbb20d3db564f5bfc8a8be5bee46e75978b6fc37fe"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cue"

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

class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue.git",
      tag:      "v0.17.0",
      revision: "0fc639bbe9819f08ed132d3981a13ac2e3bf330f"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84bc5b6804b0d9aee6a392fc04d626938bb1efcd00a8c6031458ef3705cbb2a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84bc5b6804b0d9aee6a392fc04d626938bb1efcd00a8c6031458ef3705cbb2a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84bc5b6804b0d9aee6a392fc04d626938bb1efcd00a8c6031458ef3705cbb2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e7995e27c4e34412f7976f9b2f7a44ad4bcfccf56005ffc1c0ff1f0e4f0d9a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbf75854cdb81399af064dd64a3059065a694e172476daf3e671da9a7e34c844"
    sha256 cellar: :any,                 x86_64_linux:  "2b99970d0e11fbf6c94d353c760d6cc220280e855fcab20282d8026c4b17876a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cue"

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

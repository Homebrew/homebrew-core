class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue.git",
      tag:      "v0.16.1",
      revision: "6d609d768f1686f9a3a2a20197cacdbb70e5c79d"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3312dbb6e144f0594bd8fc1d5aec3583cd316cc17900a9665d4f09eb77e5517f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3312dbb6e144f0594bd8fc1d5aec3583cd316cc17900a9665d4f09eb77e5517f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3312dbb6e144f0594bd8fc1d5aec3583cd316cc17900a9665d4f09eb77e5517f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c4bff74f92bb2f489cba7a2738afc25e0b43c93529ac368fb6bfa6ef2d6e41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1779d12d9c17b8d27e30772f7d8203f78408afed6cd8401922f5fb40b2735bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d57d40fa0b3785329070c48e0b8090c651eb9d100285bec72aa788185fb127f"
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

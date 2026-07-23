class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue.git",
      tag:      "v0.17.1",
      revision: "fc6c0b2ecd3666da92f7053d13fcfbf009b7d7a3"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28328657d4ede5a008dbc9bcf4d801da8a3a29655d972a262c9413c9beef01b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28328657d4ede5a008dbc9bcf4d801da8a3a29655d972a262c9413c9beef01b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28328657d4ede5a008dbc9bcf4d801da8a3a29655d972a262c9413c9beef01b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "253990366845c4df79de18ce17e2ac59e3d2efd0770b7349bf8089853f95f64b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "610270ca741c90e91413b2373e676c68bbe113c2dd713e278ec41d91eeff66ab"
    sha256 cellar: :any,                 x86_64_linux:  "55c44871b0e063cf490702c467b17c47498d48b3d0dc21a4755a7ae039265fb1"
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

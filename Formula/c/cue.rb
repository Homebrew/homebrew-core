class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "ecb1909bbe4a59b965cd219cb53916b09097716928275bbb55b8a8e6cc495379"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a953384704bd83893ac9578bdfdd860f503149758285d1fa9c82935e7c288d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a953384704bd83893ac9578bdfdd860f503149758285d1fa9c82935e7c288d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7a953384704bd83893ac9578bdfdd860f503149758285d1fa9c82935e7c288d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d692ded6fc6fb606a7f20a078d6d48f222a575e099ed246ff451a6ff4a81a433"
    sha256 cellar: :any_skip_relocation, ventura:       "d692ded6fc6fb606a7f20a078d6d48f222a575e099ed246ff451a6ff4a81a433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66046b181e9a4c28f52766f3fd9e0170c87f231f8cf8ca43cd86973188e718d5"
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

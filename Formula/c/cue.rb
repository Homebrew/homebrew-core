class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "3c42513fc6aea1cb911d274901d026c3263cf8f6011cb3015de5d0a04f3cc2ab"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5277b6841f7a07b2392c7e44a8472f539abcb424eda48927fea982127a321c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5277b6841f7a07b2392c7e44a8472f539abcb424eda48927fea982127a321c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5277b6841f7a07b2392c7e44a8472f539abcb424eda48927fea982127a321c49"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe5b195d99b70e14ef62a01fde4ead6b35e6947014175af7f3d4efc6c65309f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f85537d06894b9b086793e0471a9df4bb46be1baa33a86fd333834de658ebca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8142469c0569c44ec3ac8c2323c9ad4d3da373ea462c51b343f7554cd0390d"
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

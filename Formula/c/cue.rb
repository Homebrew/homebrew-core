class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a72115fc5273341a706c33488336b7c6f3974fbbd5ac27a45291b5c8148779dc"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca9b64555ac8c9f93d83ccc774115fbfbd0271fb20837f6db01518298d3c0ee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca9b64555ac8c9f93d83ccc774115fbfbd0271fb20837f6db01518298d3c0ee3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca9b64555ac8c9f93d83ccc774115fbfbd0271fb20837f6db01518298d3c0ee3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e53f7a8a0e6ca5c2db1e0939a7661d938a7b8f8d25151405b55729847b079fc"
    sha256 cellar: :any_skip_relocation, ventura:       "4e53f7a8a0e6ca5c2db1e0939a7661d938a7b8f8d25151405b55729847b079fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa2cdbb299be876c54849082fc15caef7e340750bed44848753f06012e170a3"
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

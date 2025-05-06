class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "dbf683785e5f3ee148345c31330b8aac6078e82d2d4c99c938315f5aecfeeb8b"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579de2e923c0c7d7db17ec8e410a86186d3aca8930af2d99ae0690d6aa1884bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "579de2e923c0c7d7db17ec8e410a86186d3aca8930af2d99ae0690d6aa1884bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "579de2e923c0c7d7db17ec8e410a86186d3aca8930af2d99ae0690d6aa1884bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b79869217afdcd5dc25eb65dde44d021330105b285f0fe592195c845bba423e3"
    sha256 cellar: :any_skip_relocation, ventura:       "b79869217afdcd5dc25eb65dde44d021330105b285f0fe592195c845bba423e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7f102fafb95b80f149b82a86f57fea7dc694f9369037cb5d09115aed545eba8"
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

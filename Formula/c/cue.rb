class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "a99dabdea26e8f2988b8e4f595ec686c99fcbd045c6ebc84ac8990592314fe8f"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef7cd7d63fa9e1929dbf2ccdc96ccc188d6ab508cf363d7450dc5c49c9ad289b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7cd7d63fa9e1929dbf2ccdc96ccc188d6ab508cf363d7450dc5c49c9ad289b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef7cd7d63fa9e1929dbf2ccdc96ccc188d6ab508cf363d7450dc5c49c9ad289b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4bb1663510c17fcaa58910910f369bcbf298810c4468a60bde160d0d70c556"
    sha256 cellar: :any_skip_relocation, ventura:       "0c4bb1663510c17fcaa58910910f369bcbf298810c4468a60bde160d0d70c556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78358221e7ed297460c02093d037ff9b25d11dbeca146f06ccd6d5d39a312ba"
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

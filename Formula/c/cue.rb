class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "eb6d2345338cec3b112d4d23c2862e4ad14ef0293d914c6ed4c6a0655af186bf"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5bdac475e0f6c9f37fea6b885dc67355a00e2294513102cb3a47272ecfe4e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6771c52930c3d9c54f2da79993de8fbf1302a438debad31d8c62309179134e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b1e84ce56b7f160565f2bef8f846368a03d6fd24039947059000a5d1d12de44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "119c8d283a2106d98a68ccb11ce114a7cc242e4724a5429a64c898bf6db52745"
    sha256 cellar: :any_skip_relocation, sonoma:         "585ffe040f95159c4d7ecba5b8fe6d2c987f2361d54546dddb6f70535b68c3fd"
    sha256 cellar: :any_skip_relocation, ventura:        "7bf9a8cee8cc772b5f7342d926456ff0281fd0ea67d1da1297c3308107fe67aa"
    sha256 cellar: :any_skip_relocation, monterey:       "1e8b1821e0bc298c8342d35de1816ce8f843267a53ea5958730cd2ec9472dc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53519a8ee81481bbc61a5bbc9f1079ad4f8d44b9829f6e5244a8ca019592687c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    generate_completions_from_executable(bin/"cue", "completion")
  end

  test do
    (testpath/"ranges.yml").write <<~EOS
      min: 5
      max: 10
      ---
      min: 10
      max: 5
    EOS

    (testpath/"check.cue").write <<~EOS
      min?: *0 | number    // 0 if undefined
      max?: number & >min  // must be strictly greater than min if defined.
    EOS

    expected = <<~EOS
      max: invalid value 5 (out of bound >10):
          ./check.cue:2:16
          ./ranges.yml:5:6
    EOS

    assert_equal expected, shell_output(bin/"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"cue version")
  end
end

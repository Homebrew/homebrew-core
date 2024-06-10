class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "ed75d6d65c2381ac6b2795c949f333d00e0d927277e736b296f6d12410a47787"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "074571247be91d4d74d2bfd5c4dc149dd877e38282b1e994a25c39fb65dbf605"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05e07275ac1a4782b36a1f79776f1352029675459fe8728551fd715034bbbc2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e99b83136ff8452b383633db827ebc545f11165b277fbe8dd06e677667868047"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bc10669567f23834535b98755ac48d9f04131333734ee3d51c103c7869b6d54"
    sha256 cellar: :any_skip_relocation, ventura:        "d700c47b5251e0a5ecc8b132872585b5030173150c9c50264f416fb231ff6e16"
    sha256 cellar: :any_skip_relocation, monterey:       "883ea9c1970c6b3b4cf2570b22d78c796c6ee16251f1ebe516f0cea727a4b698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae83b34b5f2f4d7039a03e921fd8f7b47a028a0132298b9eaaf85cf7de0343c0"
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

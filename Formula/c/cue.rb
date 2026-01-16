class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "73d9c4b83c452020446a069685e9d7a0998d62014cdb13cc00e10683d088bd8f"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e1ed999ddf38839a455cf7f4d7361729e3f6de16fcca86f02cb4306d93694c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e1ed999ddf38839a455cf7f4d7361729e3f6de16fcca86f02cb4306d93694c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e1ed999ddf38839a455cf7f4d7361729e3f6de16fcca86f02cb4306d93694c"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c2bf53e8316ce44d9669c7aafe4468c726b230976a56bc338a2a4ae373c5d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4dcd6cee6ce31c0eea6fac965d21e767dba2a30af895569315db8af29593af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cebb99cdc2eafd5b027f01203ae7a105295b3c6c9b14c34c3297fab5b1e6b82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

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

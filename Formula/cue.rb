class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/v0.4.0.tar.gz"
  sha256 "6989ada258115c24da78091e3692b94c54e33129f02e87ca4071240314cefebc"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    bash_output = Utils.safe_popen_read(bin/"cue", "completion", "bash")
    (bash_completion/"cue").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cue", "completion", "zsh")
    (zsh_completion/"_cue").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cue", "completion", "fish")
    (fish_completion/"cue.fish").write fish_output
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
          ./ranges.yml:5:7
    EOS

    assert_equal expected, shell_output(bin/"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"cue version")
  end
end

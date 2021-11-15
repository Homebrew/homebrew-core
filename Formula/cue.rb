class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/v0.4.0.tar.gz"
  sha256 "6989ada258115c24da78091e3692b94c54e33129f02e87ca4071240314cefebc"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3467bcd7b9bb8d45b579b7a805ebd95c434671e52e69693ec7ffadae39e0362"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b70f60ad4a8d7fcf3d58f5008a0d15534cb51100640cbc41617c4c185ff167a3"
    sha256 cellar: :any_skip_relocation, monterey:       "914ced45658ed04822d2a25aa1b5f0bb9491f57c4e2ef28d03374ef7769b11cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3845893ea23997712d12d7b5b4d2f3dcefbf0ced2aa94ccc35d251e4ee2b3e4"
    sha256 cellar: :any_skip_relocation, catalina:       "c78ec07346c1e5a82d548bbcf86caf660c111884077bf8a556c9637227920440"
    sha256 cellar: :any_skip_relocation, mojave:         "4d07f627d60bc08ea6866b5533ca1652fb70d994b630c9793d572c49edecfeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b487c474bcc5a3e2edfb1cbff973239e9915a49f045d2f34106b12c8155ad769"
  end

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

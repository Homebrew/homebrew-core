class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/v0.4.3.tar.gz"
  sha256 "3d51f780f6d606a0341a5321b66e7d80bd54c294073c0d381e2ed96a3ae07c6e"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f770a065ca36acedeb4d7db3063c4c1b5c2a4a54a9891b6587a112f7e638a651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4af3195f21ed20f27bc1015a415835728b32e06f39e84fdeb2c01b14932ffb7"
    sha256 cellar: :any_skip_relocation, monterey:       "b633119259d30ab942c77eac991f3423980ec4d90b56ae2226f6934b692d33f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "12db70d65d25aedc67b730918450fb0162f3a1127e5763322f12f8c48d89c2e5"
    sha256 cellar: :any_skip_relocation, catalina:       "2cd3e2ca353ee6e2e6616d5a9ed3112a1b9a2c742b2f30e9ada35850aa60d60e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf1e2ef060f30c188077f17eac919ebd8b3c2581fb93ac171baf028b5acc5b10"
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

class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/v0.4.2.tar.gz"
  sha256 "a45e45552b9b3e104fb65ec85891550d8675656be6dece3837334720be5d8150"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7937d3e217302811c2d14f4da98ac95e8a9bac9df999e24501e400b9fd40b04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a4487bae1dfee10402b4399c0526e4af68775d5830a727557d187db20a02152"
    sha256 cellar: :any_skip_relocation, monterey:       "1ab1deac2e63d2f9da4b08c9044c059692fd4485094092803585ae587a44f116"
    sha256 cellar: :any_skip_relocation, big_sur:        "84040311154aedad8b6ed3d77594bd6191c55632ed3293a71c2825ac777047f6"
    sha256 cellar: :any_skip_relocation, catalina:       "d6f99596f16c1fde5c658b0ad50075d8945a97ebb771cfb5eaf1ada572389484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033a16bb5887ed44d884c5578aaa4cd8e57e528a856ac6ffe7e7137ca890e444"
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

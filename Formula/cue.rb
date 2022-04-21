class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/v0.4.3.tar.gz"
  sha256 "3d51f780f6d606a0341a5321b66e7d80bd54c294073c0d381e2ed96a3ae07c6e"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33a0b540d4c796b36ac6994150bcaca1fba48a690b811c24fb6c433b6980cffc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c147059e95126101b04d7479136fb90c139f424648710f343a777a70e5c323"
    sha256 cellar: :any_skip_relocation, monterey:       "dac2dffe02c3a2270008f7b3a4e226cdae07121771fcdd17928d4b8c0f27fab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c5ae3f086df1f2d5089b83b9b171f5ce811b1e3a4926ee9633bb03cf24a520f"
    sha256 cellar: :any_skip_relocation, catalina:       "c65b682ecb73dabe2f78389387b07dff6a52cfae923dadd1dae029dcd941ce9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df3d4d368ee5bacf24ef60cb103e46b30cd191fc4bbc24fc3f30626f0e3e5d7"
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

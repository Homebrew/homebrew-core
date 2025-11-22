class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "d1bd4fe4fe39febdc07819e6feac8f8be9fc374202744d464ab540569855c7d8"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc2e60cd8e2d9206fbdf041242792f3c172a3808bab0d404ea547c3eb70e46f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc2e60cd8e2d9206fbdf041242792f3c172a3808bab0d404ea547c3eb70e46f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2e60cd8e2d9206fbdf041242792f3c172a3808bab0d404ea547c3eb70e46f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "49908dfd95a49f28c82dc6dc0bafc4d05b86d08affcd06351180e5e493ed1840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2c275509c6de23906af38b5a85365609b3d11259d8e5c331897d4def4ead772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72df844309135e9f5bfef9fcf644512f5e405cca81f91e7a39ce43f901e30b5c"
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

    assert_equal expected, shell_output("#{bin}/cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/cue version")
  end
end

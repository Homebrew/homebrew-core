class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "964556e96459f6d0f1cce1a6548338bfcb9c88051af71a1c07263aba75c26b85"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7525e2bee56f08fb471a2c1572c2f0bcf8958c7dd122261d1a54095539e70d80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "579ff886b7061cb195f93b7a9c13d019b834513815e5c2ce706e24168a65018c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579ff886b7061cb195f93b7a9c13d019b834513815e5c2ce706e24168a65018c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "579ff886b7061cb195f93b7a9c13d019b834513815e5c2ce706e24168a65018c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c664c052560e1c35a7edf4d3894f9f8d49b04eb17d7544708adb8a5f6f7d249"
    sha256 cellar: :any_skip_relocation, ventura:        "30a66bac2695a5c2c7b3e2c37338f396311e22cd228d9de69b2f7d8a1c3dbe2e"
    sha256 cellar: :any_skip_relocation, monterey:       "30a66bac2695a5c2c7b3e2c37338f396311e22cd228d9de69b2f7d8a1c3dbe2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "30a66bac2695a5c2c7b3e2c37338f396311e22cd228d9de69b2f7d8a1c3dbe2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4070a5fc5bfe013ac103e94efdafd8c5e0c162e38a8591491f277b6a67711fb1"
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

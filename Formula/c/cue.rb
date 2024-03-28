class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8892dd72df94bfafc34641a8548d1fbab6f2d3efa063f9f6a5363a1be4514016"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ab92fe21c5f41cca8826d859475615588ff5123cf726596c463b80a9672d93f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75d72b671a7a50deed0ae37b0b1d3a20abca6d2b1503e5d3084fff7dfd9bf4a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fe324a56680de6fe05c425439065c367eb85427174e53fc5290de0b4e4b3dd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f440dc832ae1cf5edd429de7352a5b31e0d5e4d11c540bcc165a3871c2af9c8"
    sha256 cellar: :any_skip_relocation, ventura:        "6f66d0c66366a443617f89c57719d0fe1d4037ef98444cf4f69dea04b32c03ec"
    sha256 cellar: :any_skip_relocation, monterey:       "a7f0076a87ee1ba9ba986f833baa1ff30a1865d35ee9e4719385aed08b0830df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca961c5d8285bcb24351ffa5dd59bd0f48f29991674a85874ccf16a8ebda6fdd"
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

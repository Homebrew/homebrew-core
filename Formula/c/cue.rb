class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8892dd72df94bfafc34641a8548d1fbab6f2d3efa063f9f6a5363a1be4514016"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "856f739aaadbb1cb32bc0b029a21ee6ac2e85210ea3cc07bb0570f4628de790f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1131a8d13fb9f48f526e81837d2a300493a0056038cf777af8c488411c8d6195"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0313a5bdd1a1859e1076b8de9873fb4d3070522adfc6051db653dac4b4d2cd42"
    sha256 cellar: :any_skip_relocation, sonoma:         "322cd611ca768dbac5bed5bb945be5981cae2a1fcd5271ca19032c7117440203"
    sha256 cellar: :any_skip_relocation, ventura:        "e20ea694978f9212ad926b8a154ff75a0d371a2b5807224699021da492be0194"
    sha256 cellar: :any_skip_relocation, monterey:       "b6db9c040736621cbe9bab0087754137d6d9f21c603917457c3b9787be87fba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd23fa4e60be3e4cf06e38663cdabb52407293db5243887a425a36b9504f2b2"
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

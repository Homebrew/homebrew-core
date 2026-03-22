class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue.git",
      tag:      "v0.16.0",
      revision: "de47a5efb4a5ee1129a470e73717f59ac03ba535"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "283fc576a33f724a6dcc301136ed9570932302305199ff73520045152683b744"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "283fc576a33f724a6dcc301136ed9570932302305199ff73520045152683b744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "283fc576a33f724a6dcc301136ed9570932302305199ff73520045152683b744"
    sha256 cellar: :any_skip_relocation, sonoma:        "97ca9e03644d7282c33f5b12528876909340ecab5b279444c2e4e8512fcde323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "356c1262b0e80ef595a17296e698953859a9ef753a5ce04d35d159a056f025f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b52392d7ad11f7f9b24d615f5b92d1712c3e243a5ccab2e656ad5fe65247668"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cue"

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

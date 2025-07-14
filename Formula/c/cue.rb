class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "3ed53c0b32e44491b3871fd22dd0cf2577a6b2ee9036c76801c261b75c4e44ee"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4d1ac6e1d54df0f77f9968fb71a11b51e64dedd27ba5dd191d91cf6b59fe729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d1ac6e1d54df0f77f9968fb71a11b51e64dedd27ba5dd191d91cf6b59fe729"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4d1ac6e1d54df0f77f9968fb71a11b51e64dedd27ba5dd191d91cf6b59fe729"
    sha256 cellar: :any_skip_relocation, sonoma:        "3964fbfd086c4b4be3a8aa5dbb4604589e59ac56a53fcffee361f7a2967e27f6"
    sha256 cellar: :any_skip_relocation, ventura:       "3964fbfd086c4b4be3a8aa5dbb4604589e59ac56a53fcffee361f7a2967e27f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5704841dfc91122211cb7c28e669cad12832075201c6570a850c563002922597"
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

    assert_equal expected, shell_output(bin/"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"cue version")
  end
end

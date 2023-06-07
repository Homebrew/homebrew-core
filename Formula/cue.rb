class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/v0.5.0.tar.gz"
  sha256 "735c39512baaf808c2ced322932fa89bf4e257a1d356dcd099eb242b95dfc893"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eef48b4d922c2870039fa0d42ac12072837c81a23f4fa39b12dbdb76e7d30745"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef48b4d922c2870039fa0d42ac12072837c81a23f4fa39b12dbdb76e7d30745"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eef48b4d922c2870039fa0d42ac12072837c81a23f4fa39b12dbdb76e7d30745"
    sha256 cellar: :any_skip_relocation, ventura:        "b93d2c673947508bbf016d34643587317eac120ca432ae22500179478ec4f0f9"
    sha256 cellar: :any_skip_relocation, monterey:       "b93d2c673947508bbf016d34643587317eac120ca432ae22500179478ec4f0f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b93d2c673947508bbf016d34643587317eac120ca432ae22500179478ec4f0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8192d638e8f9bef5ae570ead1f2bffa26146d889a7eb4d2e83b1ed6348d775b"
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
          ./ranges.yml:5:7
    EOS

    assert_equal expected, shell_output(bin/"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"cue version")
  end
end

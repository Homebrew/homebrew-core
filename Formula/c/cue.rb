class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "84af8ee44781f268173b729d29abcc0ab816a82701aa14ef1aafbd50594a6457"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0567aa9c97837ad8a777e5117c9d360d03da187bc403cda165846989919e5794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a00891a0fff202c6f059eca9ac290be9f20f4aec7e7b594465a966167d0b2c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce69619b52f74b8f0b41b24983a55b7d34c9509fa09563fd6965f386cf0748d"
    sha256 cellar: :any_skip_relocation, sonoma:         "45105bf568914f1ed1131a4fd1983f009115fbac24873c0019a517726d384028"
    sha256 cellar: :any_skip_relocation, ventura:        "a75d08525fefe6c3bf6b6b0e8e409ee36c99d30eae588aae84158a63870c72c8"
    sha256 cellar: :any_skip_relocation, monterey:       "1d115da78be2295b3653c4f2ac5be2f0df3f46ab55f5c55bc96c296f6c386947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b175f1f6c03311591fd3dbf9fe50c9254018bcbe4cc83a8ca8cc5e3c25e87ca"
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

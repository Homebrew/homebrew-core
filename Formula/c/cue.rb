class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "cc4340acc54e079b2d9fb067a0d41c1d9cf030a1c28fe1a736867d5651ace552"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f316166052f3fcb8e90e894af8440167eabe41ad69642abd7cc095246769b65f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0babe367b12c50cc4fb3f6496f4072a91e97c3db9f53001821672364a789f79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08e2cadb1e633fb449f4bc8f4785b44c4e816f3b92e8eeaf6e107e5cc338bed0"
    sha256 cellar: :any_skip_relocation, sonoma:         "06ccdb4bf4dccff25fa77fe1b53e921d9d58c742d40e75613d9044427af3399c"
    sha256 cellar: :any_skip_relocation, ventura:        "1e2779e81f75a8787f73c8db7af17087ae2f979462b529dd275635a0aa80617f"
    sha256 cellar: :any_skip_relocation, monterey:       "f39d9020003f561ed6a403bcc09e1154d9b2a2734835cea9113e0bf47208f003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a115b1a1a318962feaf64f8d0e1af0abd31f8c3335fc6979f5e532acd1596182"
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

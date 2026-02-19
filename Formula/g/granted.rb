class Granted < Formula
  desc "Easiest way to access your cloud"
  homepage "https://granted.dev/"
  url "https://github.com/fwdcloudsec/granted/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "b6e2bc8fda38f55ee4673cc0f3f762e076d2029df1d9a8552681a2aacce88721"
  license "MIT"
  head "https://github.com/fwdcloudsec/granted.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fc38f0017948caf2a7173ea9d35e43ec724d3a154dddadc424e2709eee535aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d88b56bc977811d0dd27e64e299c4aed3a0d1b3d2cba61ce732b4670821667ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ea39d3afc9b5f1b8afea1949836ebf5a2c5239468877e65a3d10355129698ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e8823f116408d8e9bc3c09f168b8548adc91f08136ab071adf0d621b54d5382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "992cad69e747ccb37bdb958e0ca36a4b877abe5fdf1c6f2c696be8ab7391ed10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8750823e00d087482eed923faa51bf73ac955269229d1222bd86d0ccbf60d27a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/common-fate/granted/internal/build.Version=#{version}
      -X github.com/common-fate/granted/internal/build.ConfigFolderName=.granted
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/granted"
    bin.install_symlink "granted" => "assumego"
    # these must be in bin, and not sourced automatically
    bin.install "scripts/assume"
    bin.install "scripts/assume.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/granted --version")

    output = shell_output("#{bin}/granted auth configure 2>&1", 1)
    assert_match "[✘] please provide a url argument", output

    ENV["GRANTED_ALIAS_CONFIGURED"] = "true"
    assert_match version.to_s, shell_output("#{bin}/assume --version")
    assert_match version.to_s, shell_output("#{bin}/assumego --version")

    # assume is interactive; pipe_output provides empty stdin causing prompts to fail.
    # Match varies by environment: "does not match" (with browser), "Could not find
    # default browser" (no browser configured), or "EOF" (when stdin closes).
    output = pipe_output("#{bin}/assume non-existing-role 2>&1", "")
    assert_match(/does not match any profiles|Could not find default browser|EOF/, output)
  end
end

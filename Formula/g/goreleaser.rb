class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.20.3",
      revision: "a6edafaafe0fd15a4725e917beac26305ba67738"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "12268979e7920d4ef8a64960f7fd7400427da68420b903b93a2a24880c100f49"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b933049185b6d69593810c05ef6272e3fcc7199e4f2b5ae46e17b63e2bf0e293"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df40e93efc610f7256aa79a7db493506e3563c0093568abab6ab4739dfb1984a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "212b8cf1b909a3dfd94bb2a73bfdb9ab23a56b94fc6ddb9a0c1cac28234f1f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "585c0f1020eb3341a4fef851cb35b99d54b5e32da808c21f70f31f60b5d689d1"
    sha256 cellar: :any,                 x86_64_linux:      "6280bfbf57e71218f9d083447bffcac9d164b9e1bed03f5d98bb7f11b87bb84e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end

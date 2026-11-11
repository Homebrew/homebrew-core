class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.20.1",
      revision: "119f88f695dc34e4b6f04c34e22005955d5675f8"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19826c7dad6ce41edff69bee559f4670d0e75b5ec145ce4149fd062945ec66dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0967379c0cfe694281f1626ea0564d857f45a1f88d8012fbcbe382b7ce80e63a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ef11b95dbec7c6733417b6dd7ceb2ac3f90cf81e6589d9c068ce501821ae79c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1371c2ee6ab74eccc02505b393cd1d96bd0b71ea2d9eda078400735416e16ea0"
    sha256 cellar: :any,                 x86_64_linux:      "d059374131810b35c899bfd09c6dd65fe656f1ecbaf0a8523bea4c416521dd9a"
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

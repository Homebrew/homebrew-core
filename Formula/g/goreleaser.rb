class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.20.0",
      revision: "b8f79e0399c46895220e8479e24d599576b563a8"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09a994b738355d7161b59a2f442ab9b4356692a732af076a3996fb39dc7cb80e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7312cea74e68a16654368d872e6a1d306dca4ff4f076f3ff949aa25018ce66d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26544309516d3e763b67af461ebae335de82d90d2ad57d2cc54fca087ce26fdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60a0a4b2973e5b40cfa153c9ec4ed70bc1a9873f13fc6964b9623f1cd06829d0"
    sha256 cellar: :any,                 x86_64_linux:      "655e40651902fff3ae41c5373261e30cde881f9861fa59d2648c2888804ecd09"
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

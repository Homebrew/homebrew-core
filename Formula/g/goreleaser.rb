class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.18.3",
      revision: "1942d44355492f44cd3774c57bd3c27fe544dfe9"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "006e00419c5bc1230c72c19ab6a8e8e91b49d626ed5a9800905e5c7b5d095d3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70a48784cb94f91324a4be17259c2d784dba5d21842f6b162edff87d8720a3be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90919362a07c3e746c0ae6802bece2527bccc929b87e43fd8583fefd7c83190b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aef831a2f2662c1178a09b4681a982a577e86ce6bf1bda4406240031f65b5295"
    sha256 cellar: :any,                 x86_64_linux:      "41b6b6789bff1a1b8ba18fc4ecedc244fc22bda8e57f3d2e0a2036be0ddc112d"
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

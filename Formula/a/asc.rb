class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.2.0.tar.gz"
  sha256 "c8d4ce26a63cdd7610adf58e86baaf1fc9304cd950aa9df97ba29fe358f1ea65"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "1730ec7b67204fd7ffbe200cb6b27861770661b786c6427a9bbb62243667602b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e465b622c197e14ea52fe5b33da7f9dc95e055e363b2a506d059a0da1f9414e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4616d1578e553a7311b76f212edd386882acec182df998ebb390545ff40756ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96cc3972ee6ea432e88edd392870e95681e27eaabc6bf5d64dc7b0acd334cb13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97a529c90eb438318f42358765265e8b613a56dbe75608e6dd1ce2a298640f13"
    sha256 cellar: :any,                 x86_64_linux:      "fd323fcef23dc7c828d4a85ec385df2b3eaf58ffe868bd78a5113f62ff5c1551"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end

class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.4.0.tar.gz"
  sha256 "c88aca89dca6000aa1a64817bdf1bb831eed8b292acc8d9641d75aed419e1f4e"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "efc3f8586ce6819d0dc22c82533ad2f588e509d9e2723ca338a81b3cf66c4226"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e9f84c18b196c2488e8cb0e5492b4dbbbd2846b4b8ab22e15e242e10066f951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ecf558d533ca5b3a3b84472190a3e5da93b181643fe582220222c461a57e74b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e949ad354535214ba3104fa42dccc8b9a9e27f094493f7959d5dbf0db6790ea9"
    sha256 cellar: :any,                 x86_64_linux:      "248251cdd680e6333cbd1e024fcb1d7fd23004b7dd952ef65ce1d806332bede4"
  end

  depends_on "go" => :build

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

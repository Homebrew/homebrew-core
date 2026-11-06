class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.5.1.tar.gz"
  sha256 "b3bfb805e5182cb7c7f94b53a62382fc9a8ebeff2772aae90bab0dac68f23e81"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "124e9031f78f113772be52d6c5192f29e065674c9065a7386a41662718986ceb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2788440387d11dc5e692534d77f3e0e73b75599b8c7fb981720a97b2ae4d0933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "136e395cda89cd1c0a1a7ab8837dfffb6b8a66dfa34d9e00117c88c05e479384"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb5834aa2147035b83c6567b170f70b59bb574899de422f64252d4f7b84cc5c3"
    sha256 cellar: :any,                 x86_64_linux:      "4acdd1e6b0dd48d3a6403a2d71ca179e93422a194fb7ce70e2804d6336a8b23c"
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

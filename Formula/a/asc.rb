class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.1.1.tar.gz"
  sha256 "e4cfa635a828dc4b0e55d7192794a95b2db2f6f0992c930af70f684311e23d68"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82db400869eb7be62f1a4d2e25adfb9ff0f0f095b3a497630732d11a0bdcbc94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3591e99ae38e76f6633a5880177b51035e38dffff8fb1c3836f1e1568f20cc34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df171ec105dd76b944ba796e12d4ed640881af40749d3dac1ee79c90a78ec34"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a8bb2476b0f5a241e4907ea7356bc763eb83a24a401cfbf61f6c353084c07c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2242fe6252723f85ce25a1fb115029c0cfa3dcc39feb066cebf5555fc7f82e"
    sha256 cellar: :any,                 x86_64_linux:  "b292a80bf04cd5bb0a1983672861bbc5dac1bf0f2e569881f57587f29b373ab0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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

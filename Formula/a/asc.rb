class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.3.0.tar.gz"
  sha256 "23aae809bc5a86b8d69b8f53ca260b278fd2240b3f57484caea9323ba8d9e43f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14be1e3cd60f1a053519b17744b1249d6db07a734cac682c9a7bac49efc77a4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1881843a2fbe59fd38c698326d2169ba854266fd81697202c156163b2071e014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9760ec530eb13d09c0385efb81437abe64bde7e287ff2ee1324d0f117b0ab32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4c6e6df3c4a72c7d3092c752a19f78feb8afc9cccadc2d1fb7602ea09ce1ad9"
    sha256 cellar: :any,                 x86_64_linux:      "31a9e59626c9d6f4d8fb7d17cf5685ec1260a14805acea97a26f6c4394b27531"
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

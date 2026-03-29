class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.47.1.tar.gz"
  sha256 "3156c5944944ab4fd2440aab02b3dbb49d695091f34860396272bef23297e194"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53658d01404b9c34d4fc7ad3e0e66e2bb27891ba17505e11b2d2ff148c72fcf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a92752c3f5cc36cf43aa9f3af0dcb233f5ac23428f057c5b3c4e9104924a40e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f728aac5a3b008556be06e908db21be4c37350478d4f7a86646f2363cbced96"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6e3067943fdaaa21e7875709ac616bfc62a0b16fd35c76bca2dbc6015ed380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2de1414c1519a3880b72be0a69b2beb8561bc12d17d35e925c765afd0e6afed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc8d5828bb30369697eb65725ddb76acd37b29e285ba82e3a17a0c4491e4665"
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

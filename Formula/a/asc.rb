class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.9.1.tar.gz"
  sha256 "9a69448b4346f84db271f76eb16266f732533698a99cd7f087d7f9eff47bcca8"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5317593af641d1c67879e5d22ffab664f88d124db195c1f0929add7162d0ce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426c51a679e61fbd9ec0cb8cbf043567417c806a8a88daf3d08cffd4a994b0e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0736be48bf339af416efeeeccc008a80f7ac6a4913a7b37be858db33dd865aa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7174da3c9e65a97589b2b937342c4977fa9d93c6be2a3915c99f4cede956c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e76ef7f7e9fe728027313d97a8742826f7ad8b2ea26c026af7baa6036a878e"
    sha256 cellar: :any,                 x86_64_linux:  "9e4893b19a5ac6a1b3cf4200d59b21662ac14546cc4ab0265393f6ed7943648f"
  end

  depends_on "go" => :build

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

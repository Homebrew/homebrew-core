class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.9.1.tar.gz"
  sha256 "49327f5d0f4bfcd8c7c8d6a6bd5ea483085af23d5b90a61c0cc080dccda65ce9"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acaaa85b9a5cd5589f048835c52dd797cd7fdb48209aa29bd85b227bee59e872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50c25c45111b8d1c8f0c5e4e0fc0b8fecfcd0e57854489b0d34f4640a3701f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606fab0fde9882955a610af104ceec5ed5727f4484937a9293b0a7f9c20248d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "075770e917aa2165a5627cfdebe8ed21f626c498afe3b8fcabc67abdc02ea259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00bfa336938cdebebc69cb3875a577a12accb286c6ad457cfd0260c213b35eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972547205ce1a44971b0e9b555e01c2e228462d71afa307de273b03655935d27"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_path_exists testpath/"helloworld.tar.gz"
  end
end

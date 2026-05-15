class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.12.tar.gz"
  sha256 "8e24657f9bec405bccc3c22404cc97e18d6583ffbafc3cd3286038f7c1728606"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "517b7f9c458526d0a4555ba1b10e9dc36be1ce33b2fbf7414bc3aa0ff07cf6c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f48314093f30414363d6de9f4f8d35e415dd81cbc892a9a1fe9e2230dee3d76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee17962c077cd577a494e6fd17643dc0a18ac6bdcca4dc7490b7ff44ad0039b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcf69b61205285244a61802cc991c20471f99cb6b08436d6b45a0ec9911a458a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e10014ba53cdde8d2b708a96692174e57db11cbe4e63cddda755098a6f9b72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb247bfebd86adcc1cb5dc51d045b8ad567a77af4ae69b74935714b8b5339fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end

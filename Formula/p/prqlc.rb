class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.4.tar.gz"
  sha256 "1d214df7827659e9573afc339078e421e326953f7954ba0cba0b996e0d110531"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7e06cd44eb914925c510a1960a2dc4300256a8110e61a48c9376cc5db73f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c415be246789f5c4f0186faff43375c7426b6a76c99f524ee8e613381ff28a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bf53c05419ba357804e4e7860f7b890d175b81f6ee5c0ef480ca7a2e7bfdddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9678c394ba845c4bac9f02060921cb912b7f273e983a5e29e222988445c75156"
    sha256 cellar: :any_skip_relocation, ventura:       "ad5b425bcd4bca3cd7150d5f791b40e8101b080aa5ebb052a009be39355bb44d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "389518823c39646ad75a842c27e22bb599b4c6959d530f869cd2feb6e78945c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d3c89c64c998f4d9d48a827e8bbb099105aef8201029df041faaf0345fd043a"
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

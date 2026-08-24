class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "acc93fa712659b881d3038db8cfeee83e446fe65ae82b8ab2741c053dc66f1ec"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0f78ba173292a667eabae05f6e469f6af9b46506c4efa41337e0cd6a0ddeb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca3675262d238fb9aaf0387eb11715af27dad3892e9667a04e926c1b27b9885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71f6772f93fcf22499c9750591d4424663758456faf6eec763749e3f39c3ad06"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a59c8284a8b53a0f9c5f2be5364b177f0b4511a790b67398e082365e15cba6d"
    sha256 cellar: :any,                 arm64_linux:   "26a6ea354c35a0dfba947157788df2e7e8c3ce5e1d15a9612a9e0ea859928679"
    sha256 cellar: :any,                 x86_64_linux:  "42238288ad3cfa00c76b52764aaccecc9ce13e98fd3b32e47076f191945c2e4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end

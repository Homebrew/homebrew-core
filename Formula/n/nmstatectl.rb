class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.58/nmstate-2.2.58.tar.gz"
  sha256 "7a65dbbdb5e41314fbb8db479c6ad78a36d1ebe094fce6899ab5746e441b5ecf"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88d12aadb6faf82f78ecd1685a95585cd8ce3e0f515a8368adb3a4acfe8b20e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e68069358a88b3a87531fa1f6f7fd17311b8eaaae4a86c970a04b19310f8e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6277b556c4593923da2e6f04980757093b11d5e77746b0d62b15ce000fb4f84"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1d33dd8e352cc383ff3e34334726ba19a3dc39f58585e4ba99055fe75e4f73b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "025eec10deb43e3917e6c236476c709f819fc1b67e972cf92be3a027944bf91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca3a0a55853197e7ff9757817a1dd25172928c31d39847bee4f7bf0dc24673a"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end

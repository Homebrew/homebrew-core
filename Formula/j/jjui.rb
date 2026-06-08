class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "8d5d8f73958b6bc0493ebfbbbf5dbb6035eb72d4ee1e84488b34d51f9c3a372e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d88a877e106a18dbc2a3824817e8e4b76d84683c9712d12895b53b9e4c58706d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d88a877e106a18dbc2a3824817e8e4b76d84683c9712d12895b53b9e4c58706d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d88a877e106a18dbc2a3824817e8e4b76d84683c9712d12895b53b9e4c58706d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5daa287d44c5570cfa24dd39e2ff794aeff5884cbf9b7b192f808b3065b84ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "772395cd22af145cd517f231b55fa217574fb7a24fc701b5707dc07d3954f4d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e7889e48660e48df1049302653fc35322ca9a005b809daa8b54f7fc330736a"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end

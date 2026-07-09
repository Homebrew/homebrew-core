class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.16.tar.gz"
  sha256 "96d5093a7257ee940454a5b5b372a5c835b49a19b4d62299104170e5526ba35f"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3323aceb3b36b53a717599e11829c5cec43b73040ec6d1a5822aee9d57be43d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64159ff83c7a4d94e57ae27825a2b5274ab8a56af21d41405126e6a79189570a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d55d271f9af51156ac581e55e99c661db7665c008c5f10820172a0ec6989f817"
    sha256 cellar: :any_skip_relocation, sonoma:        "603baed2dc00c36bade82b1164bb29aa79b9ac49d4d63b2df1d071b7f7a42b98"
    sha256 cellar: :any,                 arm64_linux:   "cd9adbb5c5effe355479a0164594298dbb3ce727cace60d14d2b6e122cb5b770"
    sha256 cellar: :any,                 x86_64_linux:  "a641c92382a7750dc4ecf39d0eac2333fdbe282d02fbe06551da13faca2a352a"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end

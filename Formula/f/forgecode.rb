class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.14.tar.gz"
  sha256 "331149cd5d7f157ca6d191362bbc7f2a48671fea9f059b6a9bf0d576c31cf3c1"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bee2019e7485e14286dad1e80bd826f1043fee2937f66e1e67d48f898c033929"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8043bbef6d144334b80a3a7fae449116caa1cfd150fed461bf4f1e6a8fddf93e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1189de1a8fce0c1cdaa26fa887426fec7034035e46303e99c6b513f36766853"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4d66f29d745112b648777b9908dbcfdf05b271230e22c829d3b426d6920384"
    sha256 cellar: :any,                 arm64_linux:   "66a9ace142e511c7fb85fd51391607d658bfc2b82fdee0dd43a86f40b5b8b0f3"
    sha256 cellar: :any,                 x86_64_linux:  "1271ffc58029559aaeecf1e5355fc11201c18f96342dfc3d163f193f0d4332ca"
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

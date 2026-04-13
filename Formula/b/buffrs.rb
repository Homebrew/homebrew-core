class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "3e9c85bc01cc4fd06b4679af19d17875142fa3c43c69af5fc5c88c58887ce234"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0ab0c17930214199bdd250c3b2eefbd06a167fc5e3763f98e18013d6adb0fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e178da7b9d4185578d9afc0993a20853688c53c9051f9ea09683a8a5a110f50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d5d37267918a85114fea6459eb79271aa45eba139549f089edf92c4aa811ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ec28b0a622393b32385b1cbaff841efe0cd3578cfa2f0aa61ee61c36d791425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533275c03b898fce03e6f41c8f478498f9ecf0a839ed521f68653325d01c6f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7d47d56670863151843404dfaf1dba57a34b1c6c5e81c186bab3d8d6f73869"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end

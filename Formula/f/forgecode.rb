class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.18.tar.gz"
  sha256 "821e3efe5d91794cf9393dd75958bd69922263a701c724b07aafce11410265c9"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb8768897b0a98377ed666b9121c8491060eaf733ba78cf6929fbad8d79e54e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "231a7df5edc8fd318f8c56a2bacf3edfd3568c92fe8a49ffd9c612389ebbfea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d94dc123843309c4b95d5259e27aa66898520d2c5c6304455da9bf140c13aed"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cc846d3047e7701356f2cbd1470f065fdc7bd7ee28e06c4d1786158ee0ba2a4"
    sha256 cellar: :any,                 arm64_linux:   "7d29680d8590e2df66934903e595616165b1c73bccf1946f1bf161f4be06495c"
    sha256 cellar: :any,                 x86_64_linux:  "cffbe880ae921f1a6990a363ffa9afac82cfb870b755a3465ffe59159f8a5a70"
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

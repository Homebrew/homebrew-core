class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.3.tar.gz"
  sha256 "1a437ce500906ae708d40b0733d65be2224d12751ca10fe585248cfd9ca67bcc"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9630cc238b3a8dd2d430fdb1b47bf3eacf757ce806cff6665e71ce0449cbb272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf5a0d5701e789b4e03ae947a613f5232d6d0f6c10e275a3edc88b48ce68d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a2bca056f245ae5615ddcfac8a877c6228ee047f4f6f17b4625320ea00adb52"
    sha256 cellar: :any_skip_relocation, sonoma:        "61547d2dd02b419a2a39d5c28b55b08bbd315424bd607d1a1e52fc0b98583136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdbaf45a31c95f831d0c9472d1ccd9f4db6ee66754f5b542f5317fbf9e86ab18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59df6e201127c0b913f0025579d8da9f1de7da4d2ea137b8c1c5889a21c61914"
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

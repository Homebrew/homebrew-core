class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "a073cbe7c3f2e059caf9fda3f33716b28481d4493e4adb8fe971d0fa1bdbb65b"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d403bf5b706b0006471852fde9efaa74fe2c72eec3d457375c09f32e06463148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64dd534e007f88da216b6d08d54fd661fd525de63dd974742c073599c32525dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb68514871d6cf03503bd24feaf423aa843c15b30367ae1569394a6cc5628de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dcb034fa8af5edfb846a8c3c325626019c3a0cd886bb10e1b25c4032d89563a"
    sha256 cellar: :any,                 arm64_linux:   "0beec294a0a72284eacb99c7c9b61196da1e2291184d05f237f917643582a098"
    sha256 cellar: :any,                 x86_64_linux:  "5ae83cf06243b008feb43a344bb88a470358f7f7982a4f502727ca1e02d20271"
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

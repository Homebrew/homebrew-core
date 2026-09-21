class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "6c53a413f9c79855824116483ebcad7b6cd3cd6d37bbf39698d37e5013b27454"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54a0a76468b214139cccc331b2550b72b5c828c9f81c94ce3ad6b1c9d55f7484"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50f9308833a4a3fb0db5abaf78f0660b0ea72f5af7c7796224f02b048b51af18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dda71ca37e11f36c6d633534efbbe9066db3da1a731c7cd4bd9eb10e799913b"
    sha256 cellar: :any,                 arm64_linux:       "12f8b2cff7daf8d73da624388d8456b409c6ade50d7b52a198d862196a76cb90"
    sha256 cellar: :any,                 x86_64_linux:      "47e4f5bf3157c0a14c6a6b3f48f849d2f931fe1925820b429e8b5a42d81de08b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end

class EnteCli < Formula
  desc "Utility for exporting data from Ente and decrypt the export from Ente Auth"
  homepage "https://github.com/ente-io/"
  url "https://github.com/ente/ente/archive/refs/tags/cli-v0.3.0.tar.gz"
  sha256 "bcc7620943ed8e3b16f5f2295ab8ff2e7dfe0f9b60abc9f95bf2139a02f27708"
  license "AGPL-3.0-only"
  head "https://github.com/ente/ente.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e90b3d7b814ad43fb45d6c89b9bc1b83c5d686018f7bc26ec33d1dae188c054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e90b3d7b814ad43fb45d6c89b9bc1b83c5d686018f7bc26ec33d1dae188c054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e90b3d7b814ad43fb45d6c89b9bc1b83c5d686018f7bc26ec33d1dae188c054"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d9a6a8a180f866e6f98d36647ac1b0c0cb429a9fbf8e87cbb27afea110b3ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20f4389aa51580b8f1455b247e7bc6d7472e9ee5121a1ca2e7692ceffb517e92"
    sha256 cellar: :any,                 x86_64_linux:  "f8305eb32e5efc46b81c1993fdb5103802e9ef52352e16bb0d05dbe9f4204f38"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      system "go", "build", *std_go_args(output: bin/"ente"), "main.go"
    end
  end

  test do
    if OS.linux?
      assert_match "Please mount a volume to /cli-data/", shell_output("#{bin}/ente version 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/ente version")
    end
  end
end

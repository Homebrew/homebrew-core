class DistillCli < Formula
  desc "Use AWS Transcribe and Bedrock to create summaries of your audio recordings"
  homepage "https://www.allthingsdistributed.com/2024/06/introducing-distill-cli.html"
  url "https://github.com/awslabs/distill-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ca48908a0d4c9b2cdc72a74cc6ec983f3d9ea665ba10e7837b641dbaf88ddf65"
  license "Apache-2.0"
  head "https://github.com/awslabs/distill-cli.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Most of the functionality is in the cloud, so
    # our testing options are basically limited to
    # ensuring the binary runs on the local system.
    #
    # Need to create a config file or cli will fail
    (testpath/"config.toml").write ""
    system bin/"distill-cli", "--help"
    output = shell_output("#{bin}/distill-cli -i #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match "Error getting bucket list: dispatch failure", output
  end
end

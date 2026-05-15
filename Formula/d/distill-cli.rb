class DistillCli < Formula
  desc "Use AWS Transcribe and Bedrock to create summaries of your audio recordings"
  homepage "https://www.allthingsdistributed.com/2024/06/introducing-distill-cli.html"
  url "https://github.com/awslabs/distill-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ca48908a0d4c9b2cdc72a74cc6ec983f3d9ea665ba10e7837b641dbaf88ddf65"
  license "Apache-2.0"
  head "https://github.com/awslabs/distill-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac672b591b503f34365dad97812bcc6a1a9e4d08bc588902869bc81bb9b7f3f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04f4b2d4fc79a2c3dd51985720064ed2d45fdeb0c8eebe82ebcb396546690d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebb99840e22f2c89819782c9994198ec0b8565c4ae700bef9d2d35f366e2be08"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3d345fd35fa7fea18d1b3e74deb80d2ff9110074e0169a1aaeffb2e6a2c463d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d43e9799ba33aaa78b3736a5ed5e92560033760125f750b9076d1176f2c9907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbefbf8904d128204acd246885dc6a184d38e5b3e56f42bf2df135a1ea4e4b0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
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

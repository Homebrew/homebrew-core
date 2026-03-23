class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "52b9c969f9fbce2e4023ddc13383db21469bf54f3d0c74e76e73ea6eb2ac6715"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dea6b89b4fe46c8a7a852cf68029b4317f358f2e4691df560854a30fd0ddd67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f7d135f231cbddd00d772b37613b7bafbda14504283e019c279fad7a432f3fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce67289a420fbecf071c9a76be92e0ce2363cd3afe134436200cc2194fc645db"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a8dd8a15d6e14dc7f2b071db6b0a98fc07c07be644fb4893e4f651f23460edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02e9d7d29d66e5b80643140d0e790d683d31790b371323eb8eadf38adb4c2100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184be637eb8edb20a5eddb57743e0f6746e4e1e26be88332571a6a63bb666608"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end

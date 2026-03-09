class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2c5adde48a294c6e52f4fe4109ec86badcfedbe25c8a8ff47f5b15812b30f131"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9430a4ce212ec4852e430d797f01cab716a679d796a3ad02c53bc90de9036a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87074bd327d79d7ed97d7c16210ed92c05cb3f80876ff1eea49ad5b72e8671a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f498b971e65cca8a038b6b813dc62cde4d238017420e812f2a07693288230aa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e242d1c5052eb3b0158f715418a401945ebc0dcd0b94f8b6adeabb92371e91b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5b9a96833f962605053d89e636f42b3558de9847ae8db1c7057ab9a3342ff95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d008606149cb752f259084197d9c3228fa38b1768ad87ea1e8cb371198c2c80"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end

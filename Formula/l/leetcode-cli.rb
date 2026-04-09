class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3ee61769f40fd374461dfe9a7cccd113b38564e828bcccabf1875d9482b9ced9"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2714994b45df5976c2f02d57e02a860397738ef3c1b33bae6edb32955636b241"
    sha256 cellar: :any,                 arm64_sequoia: "5c17215533eadbc515621812fdbce284b89ce60e365dba38672d79a197d40302"
    sha256 cellar: :any,                 arm64_sonoma:  "391a1860fad787cfcbef1fa1c0dc04335913621944da57999e89957955c67cf6"
    sha256 cellar: :any,                 sonoma:        "655b0ad5fb1c9a7b7cdc9b09c42193fa11a10dda1008913ccb748bd6d24edf08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6da7b9dd64506d8a577505d4b2716ce342bd0fdfd2b843d92996f35c7299b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6826c657dda9c1c44bcfe1f3c8b029168867e994a149cc4353e1fb849aec58"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1", 101)
  end
end

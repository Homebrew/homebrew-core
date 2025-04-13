class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "0b7af5782947a2ae5fab7233c8ca6dd59441287033e9116e332673ee6613a9e3"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74e049034f26697cbb450932850add1cbfd9d9dccb52d61d2109184f04987f6d"
    sha256 cellar: :any,                 arm64_sonoma:  "02fb5ce2daa5f0c662fc4b69b4dd82f6f7ac7ce12f4f1507e449fb91107d20e8"
    sha256 cellar: :any,                 arm64_ventura: "56de48e4618446f7e796e118826eab3da85760eddbd170c360ec85cf0d12b85c"
    sha256 cellar: :any,                 sonoma:        "54a05fea76f766c5f43250de16f9e54ed10f1866f00e9108d356e81a2aa3d42e"
    sha256 cellar: :any,                 ventura:       "c945df73ce1df6261bd90a466813d1c70403e073ced3122d8c7c06e1b4c6b281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35d29d17bc0a58d8de02b0e86d492c9d298c66060b44ecfda2b65d5d65c6b984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24708a20685911223a7b8b32575473081a36fe6bc0135f415d27b5343cdb96a6"
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

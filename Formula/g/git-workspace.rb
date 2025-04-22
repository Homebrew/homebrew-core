class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "d5e2a5a0a568c46b408f82f981ea3672066d4496755fc14837e553e451c69f2d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9e68614e31ed33fb7426fbe05bb570d6fef5c156bc78a19c483e9962c5da2297"
    sha256 cellar: :any,                 arm64_sonoma:  "faf1482a2590678aa304276e8289eec0c1b29b1d255e1448625e7750b7c5b160"
    sha256 cellar: :any,                 arm64_ventura: "499f183b650efc68eb9b6cd71535995996d3cbf0a4e6e514fc3e1ce435b1a5d9"
    sha256 cellar: :any,                 sonoma:        "21ed41579cc1a10a68ede6d9c826f547b0907bfb9b412b6ba9ae936cc1aa541f"
    sha256 cellar: :any,                 ventura:       "83521f5a7cb8977584dc9b4d666070fc53034a532fa4b5cfb3e21a0f2315a225"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6a7a925ec91fbd9403fe9a54a1de5c1991215739e9735f4135414780a57a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff145909e4bca229a0f1e7eb91f3225f0a113f1c3db32c0f7a96c5455098f8f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system bin/"git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"git-workspace", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

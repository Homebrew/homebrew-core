class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.101.0.tar.gz"
  sha256 "f0890a88193722c201406f9738f483b3348c414b8dbabc079934a6073d069409"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7d63f2f6fabc4a1bf8474eef18530448ba8979ba2007fa7a1ea8ee95d99b72c"
    sha256 cellar: :any,                 arm64_sonoma:  "f0db6d026f00ecd377d791d6fe2310bd9a3b8d2591a3b538038f4981305fc240"
    sha256 cellar: :any,                 arm64_ventura: "a62601d81ca039361c5a893d4b503d5ecc59a2119489287b491220a33170e3d3"
    sha256 cellar: :any,                 sonoma:        "985728986aa6de81ef35ebcf94198be39b8527c777746c690275d18613ee3beb"
    sha256 cellar: :any,                 ventura:       "f235cc91b8cdf6b4377acfacd2a41b5fe7c956eb0c0d48b31819ac146422c7f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e297d7f63f1614acc8fcb163d51fff21b5496eedb8eddf41673446dda135fb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d506fab7c70f4cb11b47be6315812d980df17d44f9b4342c2990d79a4d4644f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

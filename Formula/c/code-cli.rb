class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.128.0.tar.gz"
  sha256 "ec732da0d21ec2d074bd634f30878c8d578bdf14e947a62bc2d57dc516779eac"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb9efdd47a9991ee63114e0788f623b848a140541f46ea48807ba984214748e7"
    sha256 cellar: :any, arm64_sequoia: "240828aaabe2cf3aa5113ee53a18c342bdaf729a270eddd9845cdb2889614158"
    sha256 cellar: :any, arm64_sonoma:  "88978a0b8cdb5e619278af6666257b5e4e5a750a439a3c89fb18d582c7c5741e"
    sha256 cellar: :any, sonoma:        "cbe227b7706104c39316eeb1ab7d3714797f0eba601d858d5a54f0b147c836ef"
    sha256 cellar: :any, arm64_linux:   "268af43cf5dd9788c53231f87aa0423acde40f864a3e83583fcbcdd21b81c047"
    sha256 cellar: :any, x86_64_linux:  "15c94ff40fabb11d4c5faaa21c98cef7fb7ea10bb28166fc6d7566516d7bda45"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

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
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

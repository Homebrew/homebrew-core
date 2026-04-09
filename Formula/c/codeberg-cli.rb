class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.5.tar.gz"
  sha256 "09902e3511c24316e9aab4cbd51492d00eb978ee81429e873de80bc9a485c549"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bd5f830c3221b1ac74d72d87d2fc73e56600dc2136089223f4e1b254d12f49f"
    sha256 cellar: :any,                 arm64_sequoia: "83a74d50b902d8ae120a460c8536f66a8a16f4f38a494148d0fc0339d8ce3be8"
    sha256 cellar: :any,                 arm64_sonoma:  "7c253e2793055098984dbda0ce9298934d269df26a6f12833d0390895e65d1bf"
    sha256 cellar: :any,                 sonoma:        "6d5995f7e35e1db9126b3777c035b0848915e4cb1b738d2e57230583dee34b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c92e3099bddbb7a90d72b69e6d829d203202361e123072fc11838b77b48ecd72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d605e557b17e8a81d430e8d5a8bae6aec6b6206b015506a4ed8adfc497a5d2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Successfully created berg config", shell_output("#{bin}/berg config generate")

    output = shell_output("#{bin}/berg repo info --owner-repo Aviac/codeberg-cli 2>&1", 1)
    assert_match "Couldn't find login data", output
  end
end

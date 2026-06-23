class PassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.1.4.tar.gz"
  sha256 "32a3c74872b253f796291576d3dc790fba58b86eef1b9897bf5a3f4b5d54edc5"
  license "GPL-3.0-or-later"
  head "https://github.com/protonpass/pass-cli.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    assert_match "Error", shell_output("#{bin}/pass-cli login 2>&1", 1)
  end
end

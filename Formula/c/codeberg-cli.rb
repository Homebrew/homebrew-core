class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.1.tar.gz"
  sha256 "6f91dd631ec630d7b558abcc783757ea189e934aee5ea645691268f859d0c197"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91efe8b40f25e6644cc11fd3be27808838492721f99a5ed795f609dc1c3cf7a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323ef96918f9740c6e431bfbc748326684ed9d4f421b982da6da272dbc8f1dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc01fcd334144beb505210380e83dd7514146db1d31fce07887b6d57d894280"
    sha256 cellar: :any_skip_relocation, sonoma:        "222220b93d6966eeec23533a3854e5f75fb75c8a95e460a32434a57ff20f8809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6c32a32a1d231c45e72cde7ee83d0204a36e7d8296473370a5ee09a4793767f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b0183090aff316d6d089bba04b428e0f96a3838de815fca3308ec1be70f2430"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Successfully created berg config", shell_output("#{bin}/berg config generate")

    output = shell_output("#{bin}/berg repo info Aviac/codeberg-cli 2>&1", 1)
    assert_match "Couldn't find login data", output
  end
end

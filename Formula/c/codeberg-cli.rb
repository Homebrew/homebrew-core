class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.4.tar.gz"
  sha256 "dd19f9b4ada8759b8736303c24a04bc5c697d2ab72f8bbcfb13e84899cc6f635"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfcda84a25d0552cb299a1d58ced6ad3ecb83d82eb5d9dce39995ffb03d1c906"
    sha256 cellar: :any,                 arm64_sequoia: "63a1fd6335fedaac639a58946e76c6160569afca10fd1b131280e50f1f5c01e7"
    sha256 cellar: :any,                 arm64_sonoma:  "84b1be81b4ed6aa2ddb43bb735bee6d65d31556c4bd01580f93adac9bb93c9f1"
    sha256 cellar: :any,                 sonoma:        "78d9f177ee5807113a8e399a5422838fe22273a9c979730320225beef06dc3a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbd727c94f132d006db3804109abf744e60521e6ee8d0b3c6252b9991f3fbb89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d057403e008355affe773cde562accbb2a1141079ed692894942913034699b0"
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

    output = shell_output("#{bin}/berg repo info --owner-repo Aviac/codeberg-cli 2>&1", 1)
    assert_match "Couldn't find login data", output
  end
end

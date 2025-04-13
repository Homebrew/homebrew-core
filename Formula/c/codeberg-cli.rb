class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.4.9.tar.gz"
  sha256 "e5f5bcbde7f09e90bd987862e1c7217ce8993d8016d7fec20daf50056e6dafce"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21d2cd2ea6730f8ef6e08f58492fa33d91140ef96c843b0aed67ce92107f3c62"
    sha256 cellar: :any,                 arm64_sonoma:  "7de0a03f0cd0c10d0fd3cdc5f5ff48f7c5bdfa2e4b6e894fdcf5f9f5c79a2481"
    sha256 cellar: :any,                 arm64_ventura: "f8e8824143098d71ddeba4c33e58d091a4b899b2c785fc6ff990a714a325c69b"
    sha256 cellar: :any,                 sonoma:        "745cc127a2cd69da11b14a18db4aca864533d237de3d31f1dad63c6cd3b01db2"
    sha256 cellar: :any,                 ventura:       "01f84efd74f4eb2581d569d008905bd555367bf074089d907c8987569fb0d9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b49a88dfa1abef266a0adf6efbd8deb667c342ad02583d7c6329900198a7f592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff0610fc76fa040d713d925372cce80286a2b8f1f399400f94127fc2277cabb"
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

    output = shell_output("#{bin}/berg repo info Aviac/codeberg-cli 2>&1")
    assert_match "Couldn't find login data", output
  end
end

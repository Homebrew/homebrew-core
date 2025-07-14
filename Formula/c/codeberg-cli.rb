class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.4.11.tar.gz"
  sha256 "15e637ebf3cbac0bfc4175939753db14f3536c8fb8b1ef57da3f93b14553f73c"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd4dbc05182ca3546f636e0adeac3b23c187fe3ee64666fb54a03e0b213601bc"
    sha256 cellar: :any,                 arm64_sonoma:  "b7aab4dc62e541c5829689a7772881f75e9f84c6c802a983695584780d4c20cb"
    sha256 cellar: :any,                 arm64_ventura: "8406ae43d5de60f8ba5c2d29f012c19b770fb4864ed276f14b3e79b2df70baf7"
    sha256 cellar: :any,                 sonoma:        "b6a10266f12cc59094ebec6ccfe7cd4e8dd2b60e63003c6d4d6f914b651a888f"
    sha256 cellar: :any,                 ventura:       "8eb3120448b7662097e091f060860d9e83786925e346973850281eca92665d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e783102e9bc4a84144cba4341f6c73819be53c7e119efa1b1a334b1b3cb8a98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a02de1c89ab410a520b842500995aad13b214475f16cf7b9be504351dbcca54"
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

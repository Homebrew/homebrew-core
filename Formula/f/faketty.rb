class Faketty < Formula
  desc "Wrapper to exec a command in a pty, even if redirecting the output"
  homepage "https://github.com/dtolnay/faketty"
  url "https://static.crates.io/crates/faketty/faketty-1.0.21.crate"
  sha256 "66f9bcc24fbfb012d64e77e7197c42e1f45ea03810ca72630e24a5479736bf5f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/faketty.git", branch: "master"

  bottle do
    manifest_sha256 "bdd9e06c50c611d9c15dd9492643a1f8e745ed5bc754cb5b33447ed5ff5941f3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e4b0dad03c2d9eb7d099d2fe3016d2caaa28dbdaaf6b8400c639dc248553d91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92820ac01d85d1939292145678ee3c0660ebaa419a1f47e5f217a52b33a83056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4956cb6cf1169269b944ff90babb618991430de400c5c2da869d81800ac1016"
    sha256 cellar: :any,                 arm64_linux:       "645f11d29ee918246797fb256f3905924d497982cc4054eb976678e7df9d8120"
    sha256 cellar: :any,                 x86_64_linux:      "4e3eb5140b7a42f3685e673fe6029042a33ee1cc9537d3381902d7e8a0067695"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faketty --version")

    (testpath/"test.sh").write <<~BASH
      if [[ -t 1 ]]; then
        echo "Hello"
      fi
    BASH
    assert_match "Hello", shell_output("#{bin}/faketty bash test.sh | cat")
  end
end

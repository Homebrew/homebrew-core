class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.16.1.tar.gz"
  sha256 "ee61627083c80459e0f6a48c11cd910711c86b744a294b6a00f7072dffa1b04b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49f4fb0ea2630a4462cd308fd07159871134b617d04ee4fe8b822f1b3ab833f1"
    sha256 cellar: :any,                 arm64_sonoma:  "1232583501b21c4ee9315dd68a64a4d4bae16c10837981a1e8f0b6ea45f79399"
    sha256 cellar: :any,                 arm64_ventura: "a1023e1168f68db6715051a1c16246fac45c009d9509b24e2f3990a4ac3134d2"
    sha256 cellar: :any,                 sonoma:        "134df392c7219a9ef99e64d1263e483b6677d44f8180c9cb6ce4701e2936b9d1"
    sha256 cellar: :any,                 ventura:       "cda14df0d4a466aa06feef91dc35f5fde6df916a7db24ea0bf7809dfa07b2fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d261886646d80ed00a9ba4d5f72154d5c104e40489b1b3c16f6c112bfe7908fd"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end

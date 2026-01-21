class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.22.0.tar.gz"
  sha256 "ea1e0574f76c0541b014eab3fc32bf0bdda845a0e917175a5013f7920bea67e1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e119a45c76e6e54922666dd5f5e288eddccd1da0ab1835d9f39202e3303c1d7b"
    sha256 cellar: :any,                 arm64_sequoia: "0fa88d82c193c85e40cfa696b96b5b9ad4195d1fbaea7675083623f6904f0d09"
    sha256 cellar: :any,                 arm64_sonoma:  "5c40309cdd80ed816062d028c7b8bc33bf8613de5eba99d2d9464e9249a32108"
    sha256 cellar: :any,                 sonoma:        "653ea4644eb47a190b00835210bac594f15cb642dace42eb0d808208a0aad3a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ffcd95c51b24c43655c46826dc7aaff60275020817223ac2a44d5cb86fa3164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96b7334a6f13a57aab145a95ccba6fd3d46da2cdb51cdaddcd9f8bce03543e21"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end

class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.20.1.tar.gz"
  sha256 "d030de91cf5cd96924987461911aa04e78404f6372e0734e20a5c31e2df4608a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5b38aee20ee3026959263c0ec8dd9c78bb145847747713550e27ccd7c71f056"
    sha256 cellar: :any,                 arm64_sequoia: "4c8e34b147a4243926c72c09695ac27fa414343410ba1d195a8ac8cfab05ee61"
    sha256 cellar: :any,                 arm64_sonoma:  "e7e83ad53d0bbf9399c2e3aa4827e2df956a4b9d7ce87e419f89bc4d5046167b"
    sha256 cellar: :any,                 arm64_ventura: "9b862d37f0e2b1e01094a42b72c3b1950b65f0ab0604cf197cf6aab6cbc2c07b"
    sha256 cellar: :any,                 sonoma:        "2a448f94771692d7c4a6af033abb6df67e0871fbcd7e2f5fc8ab94812725613d"
    sha256 cellar: :any,                 ventura:       "0e5a6627d1d6a1c88bdf04b6df9cd3b55e6e81cc92d66a97ac40487fd5e8d21d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d1d6b0d846adc52dad821d92eccf73d07e860fc6190659fcfd0284fbad1357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9be138d935eee841b506b6be25394f638f45edc829042a8780ab557ebdd12b9"
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

class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://github.com/librefang/librefang/archive/refs/tags/v2026.6.29.tar.gz"
  sha256 "913c3ebee055bf3894f6a436e21ba99d26739fe6cc07f03cb1ababbf74d37e8c"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a7d413c4030d4591d6f9084cebb8d1c50bb94dc273179dbe3e7a0399779fecac"
    sha256 cellar: :any, arm64_sequoia: "57997b97fc6eeff8e4a711dc8d36d41826284e7115f4e2a471d2309b664196f9"
    sha256 cellar: :any, arm64_sonoma:  "9d7f463ef39a5d12a53ec4b6bb521b71058620d157b7d3ffbc10d67acc9cce54"
    sha256 cellar: :any, sonoma:        "3e1b1f950374f9a58fdaa936335c2dc11b053f6020aac41a6ec0fbc193b45f6f"
    sha256 cellar: :any, arm64_linux:   "d8c1a1cebcdf04f7d64ee55519d556df7d604722527c8343e9e7cdc9d5c4b240"
    sha256 cellar: :any, x86_64_linux:  "9bcca4f66ba2971276b1f0deafca156734e66652fe5c29e1c7a4eec1d9e05017"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/librefang-cli")
  end

  test do
    system bin/"librefang", "init", "--quick"
    assert_path_exists testpath/".librefang/config.toml"
  end
end

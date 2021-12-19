class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.8.1.tar.gz"
  sha256 "88416f4c674fdf76cb92cf1b744b4f246116aaf9bdbe0da05a3b75f73f64fcf5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21adc8780a508fe8b1658ee97c311872c70a4b128e1b418ed6c40dc31cdd8e77"
    sha256 cellar: :any,                 arm64_big_sur:  "55b37f63dee5c3c3b5d5a9b3538c47353675fc1b073485e8d91b61366c70a16d"
    sha256 cellar: :any,                 monterey:       "939d18a8a9b6ca1496b24346f7a295de70d3178084867464b306c0e796982885"
    sha256 cellar: :any,                 big_sur:        "dc2fb24eca3febbc316863cda9eba189fa27114494f39cfe80e8cc4dda887aec"
    sha256 cellar: :any,                 catalina:       "582e9d11bd9e6aa3ef090e57527639847687927a5cb64b3709c5e1eebbc21a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a0202d14cb9651be9201f324b5612a6cad5bee0747957b4d4094259583ecc8"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 1 OK 🚫 0 Errors", output
  end
end

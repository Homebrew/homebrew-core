class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.10.3.tar.gz"
  sha256 "f044d8a019a6bb3fdc553bf8e67bffa566494bccd85bad35130ae71faa7e1aaa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2fdf293d21e1b223840a9ea404edaa8933eac2d08554fe43a5dab29b9567ce7b"
    sha256 cellar: :any,                 arm64_monterey: "8968e9a628af392ffcabbad30de97a301c50d45293b5cd372743907d29b39cad"
    sha256 cellar: :any,                 arm64_big_sur:  "cce5d845ec5d078fa288c45c8932f01abad9e13eea2ec297f69669fe47b9544e"
    sha256 cellar: :any,                 monterey:       "45e2a2a19f094de6ecd786b74c894ddb2017150211214c9cce9bc7821444a3b0"
    sha256 cellar: :any,                 big_sur:        "bcdf9fa508cf8e3c4565889cc01dcbabccb9d9bb82fc584d6d0596dce3f5360c"
    sha256 cellar: :any,                 catalina:       "3c8d73d52b72fff8a38d4d57424bbf1f0708e031992048c75409a5155205d60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c58c47c98007d095fbf62cc721aea0cf32df645edeac20fba368e829cdf59b6"
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
    assert_match "🔍 1 Total ✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end

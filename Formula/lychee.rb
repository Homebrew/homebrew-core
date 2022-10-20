class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.10.1.tar.gz"
  sha256 "1ebc71f8741d644cdc1fd3f5c2f78f0991bc56e038c1132cbe8c9eee144c8f03"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "160c113fd0078c9e592bd443ad7b07626f2aba285fa7e0ff3b440936014b041d"
    sha256 cellar: :any,                 arm64_big_sur:  "83f629599c7c6ab7f4598fdd16fb922965fe917fc8c28660684eecd70ee5afee"
    sha256 cellar: :any,                 monterey:       "f60cd6918e318111cc6844c07c7b028de75d92a7db8dbfd5962735ece383119c"
    sha256 cellar: :any,                 big_sur:        "821375c5da9d128d81360d2bf0344e6dde9e9a188d5c47b551df15a1d2352695"
    sha256 cellar: :any,                 catalina:       "816dde2ad0fff4b5c347de5cdd291c0efa321324803567fe3963ce67751296b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec7226eb55b42fadf540941fada4dded040ee2c2630aaa422003f8ad80a9b166"
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

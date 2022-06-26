class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.10.0.tar.gz"
  sha256 "e7f8ae04c0d4714c4116f5cfccc41fef4b469d22c568a4f509c949378b30cafb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "357d4a2b723b71507078ec3a59a3cd7019621ce1dd652e378473ee3cf89b1392"
    sha256 cellar: :any,                 arm64_big_sur:  "46c45eb9347310c84c270028294f9131e10d2bfe3e35cb0468de8d58607b24fb"
    sha256 cellar: :any,                 monterey:       "03aa87a06d459f960315da71edf5cba85aa10f913da9f7ed5e96c38bd6e2a811"
    sha256 cellar: :any,                 big_sur:        "92f756b7b4fd9c51e2f77e393adbb3a98eb514d7b13fda0c14204ed2da23668f"
    sha256 cellar: :any,                 catalina:       "3233f07f464bf5411805738b7e9c61b0b4a6c66733cd2c90f1934e908172003c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f5a6498cc9e3f7b728cb0b3765cf225ea602de21cad662e3514886c28549f8"
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
    assert_match "🔍 1 Total ✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end

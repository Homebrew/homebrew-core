class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "43a357a6d30859f2f6e797ddf96f35c278b5f0ad7dd1bfc70c3b6d3f24e89dcd"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2ab8b2461f82798497f1fbcabafd377d47dc9de01bdda39ccd1327155c6bd7d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70383d07768ee266589fb68153f475d2a532a52d65c9b4735bb591e595247756"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a00b75193488ac82165f59f6c8cd5999436a1fad98a21302a2f72fc2a363cff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2e0fda330d41c94bd5ce41e82e04d9e897a4e1fecc8d7951dca3fccabeff0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d88c36a1c245aa7c108c9bed1389c4762dbf0e9325a891ecc3c7aeece155dbf7"
    sha256 cellar: :any_skip_relocation, ventura:        "119185f87ee1a7368b93b6a081b21d4e84e10bcf080deab904d76d90d4bd890f"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b5374da1d1e2926e5c734632570d9a217d5d20ddaceef28171fef326cc285a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6863918a25b7da026077d19d297b4c6e54185d1ed790027de0c44ae6566baef2"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/2048 test")
    assert_match "All 13 tests executed successfully", output
  end
end

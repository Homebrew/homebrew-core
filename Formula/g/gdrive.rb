class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/glotlabs/gdrive"
  url "https://github.com/glotlabs/gdrive/archive/refs/tags/3.9.1.tar.gz"
  sha256 "9aadb1b9a23d83f5aaa785960973bef1c63b85346de6be01a36e0630f2ddec1c"
  license "MIT"
  head "https://github.com/glotlabs/gdrive.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8532793c6c061b16d47eba60f8def373002a6717c2499d49faa35f7ecb1beec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "597b1a565f70001989177d007d646750cc7602948deddc79c84d84a5ad4e43d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f46421761f47656b69c91d12f132a512c90a622f032e22979eaeaeb492158c80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d43198708aa0d16925a7183cc028ea7356a42c2c6f25366dda2372e6310c227d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fcffe4b624640c73631bbbe0872e14e60f8e4d26bcb38bc15d4d01e6236ec6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2389051617cde44c9144ddf5c0696dea4a7cd16f8c940c6b50366bc762d10ae6"
    sha256 cellar: :any_skip_relocation, ventura:        "1e67b9d2936b20f5460fe4a2117b56d34fc49fa0c5b25edb8b2db2159deb7036"
    sha256 cellar: :any_skip_relocation, monterey:       "36ff90fdf725f1615e6546897b9c4c3d78d47d4ceffc98f4d5e13af00b6ba303"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2301145fc193009fb8137c3382b798a2085b1de22efbbd4c19686d01e99b712f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048b5454b4d9390a1258ca0c9c731aa8a8e5ba871ccb20e7691b1f9486862bab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
    assert_match "Usage: gdrive <COMMAND>", shell_output("#{bin}/gdrive 2>&1", 2)
    assert_match "Error: No accounts found", shell_output("#{bin}/gdrive account list 2>&1", 1)
  end
end

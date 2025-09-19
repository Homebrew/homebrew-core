class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/leahneukirchen/nq"
  url "https://github.com/leahneukirchen/nq/archive/refs/tags/v1.0.tar.gz"
  sha256 "d5b79a488a88f4e4d04184efa0bc116929baf9b34617af70d8debfb37f7431f4"
  license "CC0-1.0"
  head "https://github.com/leahneukirchen/nq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4c175806ee39e0ed6fd4efe5a59ae650c99226d48e099762c81ef36f61f369af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0d6031b33354064a349d6788cf3eb9ae0be6850f77db092b70a9b42a522ca15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae28c7a5e20440483a4e5b28b0d1ee042484fdc9f350945eb529880bd3ff491e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e707baa4138b15e50ebce902f36c011180a3294c5391448954c81dd94378de1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "532896b3958f00fc540461bfffa1864dcae2d51165c100a8eb42de5ce734f021"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2cc1df79c5e57c03e1356d2c574477d43c0a2b4e3b43931d11137716e14065b"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec6ec8c64eb5462a319fc640f4c8be7fbf7df78fef3633d28244a1030f80adb"
    sha256 cellar: :any_skip_relocation, monterey:       "f4b2a60136050855c0446ce1e7d9baa890541f11e9bd7991b54f8fe8dce36054"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "39d11e9a09a0007d3a1b94485f6cb005b6ee3f08201a43187d8b85b0a1b2df74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af85098406f38474034563e06b631e0fb9671331bbb057a9c3f0311f086f51f"
  end

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nq", "touch", "TEST"
    assert_match "exited with status 0", shell_output("#{bin}/nqtail -a 2>&1")
    assert_path_exists testpath/"TEST"
  end
end

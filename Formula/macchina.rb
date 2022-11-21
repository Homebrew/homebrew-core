class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.1.6.tar.gz"
  sha256 "1183b3ed710579e6a3fdb80ef63a9ee539ebbbe56764fb5fa3c4a0249d0eb042"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b83b8757e278b63701c3753c730be607263386a63e2d563efc0ad6e30f14b3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbc35a1ec00a5308111137ae9c393e4c5b957b4bbeecf7cd87bd53766dc8ac44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "825edfe2ef70ca769b0d9c588089a7a1eb061b088f725dd6c80c2b479c529340"
    sha256 cellar: :any_skip_relocation, ventura:        "0e0a3e450b7fb0625588e3dc750cec13fb5fa15e6014831243cb354d8bb48b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "6f7ba54b554d1728a0d7e2a19c6b9654adcf422c87b3229fb524263e1a153a18"
    sha256 cellar: :any_skip_relocation, big_sur:        "acb985865a243c3ea63515ac2b61fc3acc712f648ebbd82a8a49f59b9ed3e32d"
    sha256 cellar: :any_skip_relocation, catalina:       "3c94a12772dda424b4e10a56724e5de9b2c0a499d6c4c5dd4ff2f07ae1737c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fc74f24f46d864bb3805db70a464b457ff0b260f0fd0f6b31804dd3ae1fb6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end

class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "c955d84b3a2c28830b7042c8d6e6c9084509a44c436bf9a2a873d2d57b71cd13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aadd4145294832bb28f3e7d7ef0a96c7d93be78fc9cc24abed572af6804f4a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c7d0b677ba85e9bf5da130af783d8d0a62e1ca672dbf71000c894358591af7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68daffdc5c81c5aca974470d79ef100f78642c4b82bfe40a6a35e0bd35304f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92883ccccfeb4e74850c6490f590c8d42915a91df6a7461f60cd85c4467edaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "647ed788257bc0b649226118ba3edcdcfe4a6a0b08e7afb5d690f997e822b47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72961dd2a9f193d161e1cdf0fa516fd9587b24e34a600b3194ac0f6f158df39"
  end

  depends_on "rust" => :build

  def install
    # Workaround to build `aegis v0.9.3` for arm64 linux without -march `sha3`
    ENV.append_to_cflags "-march=native" if OS.linux? && Hardware::CPU.arm?
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_path_exists testpath/"test.sqlite", "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end

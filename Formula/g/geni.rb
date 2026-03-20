class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "502092df412629b6a38862dea074edae022f41deab8d7da48445ade3b24430b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6a5359e78bc6b71a9189c22079a1678404f02d0ef7e7222757ce5fb9c808cec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beda34d1febe4a0a0c975cc6b01a9671c8cf2311ea560c753b427941be4fe4ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3748b5f00546667d5e79caccf1c936b3e5b6e1580c5c2ca250acb8770f436b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf5a2eb2268b91b9b8581aee3ff3e10cfc1c54872492d81e4cd3c7afeddfa223"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d591a76d2d406f9b42aa694b8b90f6b3c8cc683497639cbb710beccc823f5fc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f36a0ff0a1d9e3d6169f062b258c7a3b799f5b66a2c9990280f2efe0653f278"
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

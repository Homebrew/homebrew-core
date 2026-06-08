class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "fdb9b9eb5a2b650ea7225ac18a1f194a3fd9804193b9237cad35be595c337571"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a48a83285c033b5b81be70c3f16ef9c5a01487d27dab80ab36a86a52091f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c4d6d1695a3bd23dc9f92bd0de2f77b274b66c44f18c9a39ff39f9a2fac6fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b84362ab84a95b6389294ff4f97b6f7789a80e2d05ca352c5cb5d4ca0517d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc090f0227610495a89cee288b3c2689a1ccf1f8348bcd6e20a1278f3f59a2b3"
    sha256 cellar: :any,                 arm64_linux:   "c901facce96ef1978d2dbcd73cba67ee3e7df3c54a6b21362efa3f78375bcd33"
    sha256 cellar: :any,                 x86_64_linux:  "b13c1f2f0b6ff2a60c50e1fa27cd5da88d134fceb2cacc273333500188363248"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end

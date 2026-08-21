class Binsider < Formula
  desc "Analyzes ELF binaries"
  homepage "https://binsider.dev/"
  url "https://github.com/orhun/binsider/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "78d8ccb0497fd32bdd3c46d1ca6557725154af179021b30a00150e96e4ead8f8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/binsider.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb174c262fef03b7bdb8764bdba5aa421b00f888843296e1c6950e2e96d43c14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71939a232ef4e8f7e6791060b0fc12085b33e48ae7e28e78ba9336185d2fb017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b264bb2603ad5dfc863a45f841dceaf74d8ed018915b6574f30caae0eb8438d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dd432e82e9de9c566f17eff18f24cd896ee33110a420dc4625d24594f0e389c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d554a2e39ef7d49cbca53cac30b77d156f91eb0e67ffea8c8469464b4fefc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb237cba89a8c27b6b02cc27839349b37b393c420bcd2f6f1d88589e00751f25"
  end

  depends_on "rust" => :build

  def install
    # We pass this arg to disable the `dynamic-analysis` feature on macOS.
    # This feature is not supported on macOS and fails to compile.
    args = []
    args << "--no-default-features" if OS.mac?

    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/binsider -V")

    assert_match "Invalid Magic Bytes", shell_output("#{bin}/binsider #{test_fixtures("mach/a.out")} 2>&1", 1)

    require "pty"
    PTY.spawn("#{bin}/binsider #{test_fixtures("elf/hello")} | tee #{testpath}/out.log") do |r, w, pid|
      r.winsize = [80, 43]
      sleep 5
      w.write "q"
      r.read if OS.mac?
      Process.wait(pid)
    end
    assert_match "/lib64/ld-linux-x86-64.so.2", File.read("out.log")
  end
end

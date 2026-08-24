class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2be1bc8cd096791930d8c3a811b19992a681c2aef76b28276ecb39ac50732b03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "728b0f27c2978cd2e47a69137a5af43f5fdbca1b5be11ca3c66177de741645c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f989ddc8c953f9586ea646c70064625de80a2478e7cc64ca057fdaeddb0a6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0732615e5111d57522af13bc9a2a7bc106d346c9d5fec064b742592f12dd162e"
    sha256 cellar: :any_skip_relocation, sonoma:        "59c8b1f04dfc451411d3eb7ff75d5a842a4766dcf602c7c23be76eb0d93937b4"
    sha256 cellar: :any,                 arm64_linux:   "7ae480d7ec9afacd8ee55c08f2a0d09e3b27e7447e527b54da3d855b2547e606"
    sha256 cellar: :any,                 x86_64_linux:  "ee65da7eac5e82a4f5217c8b84d6a9c8e0d7b8cceb61633b1bec4660227a6328"
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

class Kibi < Formula
  desc "Text editor in ≤1024 lines of code, written in Rust"
  homepage "https://github.com/ilai-deutel/kibi"
  url "https://github.com/ilai-deutel/kibi/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "2905743c8fc065054d3776e9b16fe89903cc0547eaedd8d33b66d2e29ceb0191"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c51c006ffda9e70d5a6637b66027ef885a761c7cde1d4bfe9ba2bf2c0ce7659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f58c66aa6678216a7911055f04e8e24186159bbd3e79329fbedf64767f362a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d550292780df1fae5a1922de8effaf4511ebefa6d3da1ad7b5918192cea03289"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed7cf19374206adaada66a435dfb1409de9e6009b4955b001783f696e3e1ce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14f5419bb8c1f24ada37aa1344b36c10dd3ed06c0e2ae66795f375cac45e771d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdef5d92ade0d33b2b8c4d24cff30b8535f94917b80a9909984910df17978d18"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    PTY.spawn(bin/"kibi", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0013" # Ctrl + S
      sleep 1
      w.write "\u0011" # Ctrl + Q
      sleep 1
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    sleep 1
    assert_match "test data", (testpath/"test.txt").read
  end
end

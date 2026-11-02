class Cabin < Formula
  desc "Package manager and build system for C/C++"
  homepage "https://cabinpkg.com"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.18.0.tar.gz"
  sha256 "2b4545a884df243eae5aa1fa214384cc8b6628ce92ad4f8768ff7d2e270901f3"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b65193a968d411685e81ea8dc673686df735c344279dcdd34f5cfed5daee86f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9909541b79799233cc3db38c8130f767a7252dc77ad7dc74c4d40d2e55cb9f4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb4aa8ecf10573d5d529359ceffcec2ca357ea00abe77f24ed56d47a0fa7010a"
    sha256 cellar: :any,                 arm64_linux:       "74e7ea7c8db56eb094e52bb67d04857eca222ae175a7f7795a561741c4cc84ae"
    sha256 cellar: :any,                 x86_64_linux:      "8cdd7aaee70d854ebe9f696cca6bb108a8164233ce3e4d50a64ab2443b0b95b4"
  end

  depends_on "rust" => :build
  depends_on "ninja" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cabin")
    generate_completions_from_executable bin/"cabin", "compgen"
    system bin/"cabin", "mangen", "--output-dir", man1
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello from Cabin", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end

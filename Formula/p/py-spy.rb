class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "6abc303d4e2db30d472997838f83d547a990df7747e1d327249a757863ee9225"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c57da0e3df21cd321b23697cf85e673332e3117f65884b36dd3878c6220d493"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ddf6302d7bbcf54e77d35b76010be52f915621d4c3eb3a8457d4ee0fdd4723d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab14c15a32b71c5b79c38adf7cc9ac1e433d64f7a52f3e1f9ea0360d8d9af08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a444ad8b9393d62f247af02a176e0f852e6a34a3add46f0e787b5e8b3da30747"
    sha256 cellar: :any_skip_relocation, sonoma:        "a40ac52cfac0d14364a85f73c76a908c70c0d218e4014081c6751eecae51164f"
    sha256 cellar: :any_skip_relocation, ventura:       "7d5ffaff6bf0881536f31ba00b04acbd770e5947a6c583d5eb246475879e8bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f6a6fa9597398cf748e685d1edef0c898f84319213a3ebdfdc1186945a0680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a7074dd2174a4cd2980518b33cb54e59883a7a90e4c04553dae7a5cc5dcba1b"
  end

  depends_on "rust" => :build
  uses_from_macos "python" => :test

  on_linux do
    depends_on "libunwind"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"py-spy", "completions")
  end

  test do
    python = "python3"
    if OS.mac?
      output = shell_output("#{bin}/py-spy record #{python} 2>&1", 1)
      assert_match "Try running again with elevated permissions by going", output
    else
      output = shell_output("#{bin}/py-spy record -- #{python} -c 'import time; time.sleep(1)' 2>&1")
      assert_match(/Samples: \d+ Errors: 0/, output)
    end
  end
end

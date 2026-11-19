class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "7bfa9af280f9c154585d44746fffdb52eccbb4abe010bf0b767d370ab23d4c9c"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3c8c526cb6d765112f1067e19c5649e978556e319929e1128491fb48b1386b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4dc7a584c166112133c331ccff2de17c67042fd0d5227aa0376438077d960866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae0b2b51af798dc8e94ef38954eb5d1eb27c558bc37ce3bb3e4433fbe5a7d959"
    sha256 cellar: :any,                 arm64_linux:       "e3ef563ea28b1e1f8ffda669cbd3fe9501aab4cb0da26bb9617c4bd6d8f979c0"
    sha256 cellar: :any,                 x86_64_linux:      "3a5b1b495c9185d2b0eba8a8729a2a0ca5fcc02c1a74f518be56a16227de7d45"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "python@3.15" => :test
    depends_on "libunwind"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"py-spy", "completions")
  end

  test do
    python = OS.mac? ? "python3" : python3
    output = shell_output("#{bin}/py-spy record -- #{python} -c 'import time; time.sleep(1)' 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end

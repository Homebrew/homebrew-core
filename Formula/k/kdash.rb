class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash-rs.github.io/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "81483cfcacb68ea04a278d576265eba786f44b3d1a7915efb7293e35b4d746f0"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e6cfd24486c1fee5a2438521f2f60f4649754602a5fd85f79e5f9389806046a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa876f24dd7c7c525976f8831cdf203e73b8f6048f625f7475cbd24301c304e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15a76ea3e08cb0d8e6c3734076a4009a2f2872c7989c895c0a7644a8ba5d9f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdfc6ad50c7f2ea413077018a950927739af5773d53391d5b044aae91a5d4014"
    sha256 cellar: :any,                 arm64_linux:   "ec9335ac1f6f64e230ba2e0b8ff8ee6dd80d61eed229de34062b25a7079932c5"
    sha256 cellar: :any,                 x86_64_linux:  "d0592850c0f3bf641b4b073e68ad26dcf08eacc82bc6da3773419b3ab9b920ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    require "pty"
    output_log = (testpath/"output.log")
    r, w, pid = PTY.spawn("#{bin}/kdash", [:out, :err] => output_log.to_s)
    r.winsize = [80, 130]
    w.write "\e[80;130R"
    sleep 1
    r.close
    w.close
    output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
    assert_match "Active Context", output
    assert_match "Resources", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

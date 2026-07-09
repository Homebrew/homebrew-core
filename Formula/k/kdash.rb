class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash-rs.github.io/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "8ace7afb62ce32ed0581528a583df1ab12cd0919ce05ae4233b8419dfa0e7344"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "433d61edc91557131c32c3b72fb763e7cf0d225541625cd5c566e9f006e91b80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0629663febbe134d225c5d77f34095228d8ec27df5644ceb329ebdb09f2811b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b3d535558cd0328f55ebeedfbf58a2683613f026da2b90d29ff043af6e5ca1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea266c9f362e31f4288f0f138c2e6db0f680865ac6fb06a7f64a20cee0ab441c"
    sha256 cellar: :any,                 arm64_linux:   "dee05d2d9777508172fb6968598ed592997a43863d6d9f210fa4f1d8e9d85ffc"
    sha256 cellar: :any,                 x86_64_linux:  "10782e857fa0e64b0c3818061924a68b8cfba48e7cf8ab88a5d69d7d408b3dda"
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

class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/3.2.1.tar.gz"
  sha256 "c9ee5227aa7344fae0444ff8d1da0c6f74240fea7226796dffc2438cc581aed3"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a277040eb6e83b60cc1b7b6bf5375745c103fe6287af5037e5027fadf239b0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d52c38582cdb059fd659e62bbd3b6015018115f857875bb9616063ce5e4addf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30ae888377f23bf7e5e77d3519a1b15326d35003888b9b8accf8024534f32d8c"
    sha256 cellar: :any,                 arm64_linux:       "03012c790d3b8d1e99e2264e21a09b18bcdf69cce4166199a2b94835f0126cc0"
    sha256 cellar: :any,                 x86_64_linux:      "42aaea9f8eb0c1ccf7788fe21dbfb6deb8bceb0d7dd6797d89fb3877fd65db57"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cpz")
    system "cargo", "install", *std_cargo_args(path: "rmz")
  end

  test do
    system bin/"cpz", test_fixtures("test.png"), testpath/"test.png"
    system bin/"rmz", testpath/"test.png"

    assert_match "cpz #{version}", shell_output("#{bin}/cpz --version")
    assert_match "rmz #{version}", shell_output("#{bin}/rmz --version")
  end
end

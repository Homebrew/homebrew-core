class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://static.crates.io/crates/overtls/overtls-0.3.17.crate"
  sha256 "a34f8961c2f58ace0a34917149f8ea25211f35821f4bf5326b8ea2d2bb81ffbe"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "360c274cdd6dd4215f806131bec1934f001c8a05c5a0e6fb850b19e596077862"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "065e7d0736a2db609a48caf061b6db48ae3a5f47350ec52afa7e056204e58776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39685514004ffde5d28e6881697b1634238cc3bbb3a201b46731f4700f9a771e"
    sha256 cellar: :any,                 arm64_linux:       "533583b75c4d152bec25f0fd42a81368638dafe03f3bea2328ffdb23a85019ad"
    sha256 cellar: :any,                 x86_64_linux:      "bf1cab0e70570e1cd79657acc98e5a7564c0a30d7b725a07f7145c5b377d4944"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end

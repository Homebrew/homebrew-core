class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://static.crates.io/crates/overtls/overtls-0.3.18.crate"
  sha256 "eff87b0b843290b3dfbc436277a22d34359c5e66a857f907c8167bc86e102283"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "529c00ddb993d9df2dc95e5c4accc4fad9f6e79301f8cc0b5f38fe05d5a2df3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60ce4798e126c89e669fad554156bc8bf6603fce5399d3ec8f5bfa24b2112304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41583aa1a086ca885cb142ad97f65036189c6ffaed6a315556f5aad889c765d3"
    sha256 cellar: :any,                 arm64_linux:       "0e0f1841be51be11945c3363361cd985c4677d55d29069c3e0a2f9a33a6ac805"
    sha256 cellar: :any,                 x86_64_linux:      "f2ab1d97096fab66491a321eeeb6e3ab831284436381f9e66579e53be4480250"
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

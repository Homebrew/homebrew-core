class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "fc115b8cd7bb05aa8e126e627c943be2a3e0b09f0c86e9d188745a15828c8843"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efa9adc1c8faa29c454648cecee15d3433711c49785dc09f03e3f2e95cf241ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6249a797445380de4dddf417153caf3ef83f3ce18a9f5d4b2db88418b5b1c64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93213f3884a6a008e96a6e5d5e874928c0d0bb2db984401a7d56b92203ac0c0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6e02e710ae8a0bf7ef2b6e034035e67a3bfc29ca880864603d0c59d66f98a4f"
    sha256 cellar: :any_skip_relocation, ventura:        "c1aa80509f625369704e8ee983d48ed7aed7935e3563fbc77a7ff7275b6c2d81"
    sha256 cellar: :any_skip_relocation, monterey:       "a5047e6eea6a7971dfad5bf3643adf8b6e2b6081e35d035746278ac59d467a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "139cc1a5eaaad4b0be4a6def7d8b3b83d429153662153fc55d451f887c0d699c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "kind: TimedOut, message: \"connection timed out\"", output
  end
end

class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.44.tar.gz"
  sha256 "9aaa7f6375600940e6073e6278bb335c9000eaeae5255e0b7692eff0f5f034b6"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b57eb3af3ec2d10f3bad3f09cb4f27e3fa1bb0b08f7d60782fe8a203cd17706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b272b70568ee560c10c882af7fa8e4234cc2c12457ea6851c00d2a6ce12941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21ab64bed1310eebe0efa45a9372e35e95fd0fec078e17608860f9a94ab2b642"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bba82ea3a1b51684575883d63298b72b56868e3676c97ec62a85656dced04db"
    sha256 cellar: :any_skip_relocation, ventura:       "68ddb87f9b04310fe9696bf499b50b9e5be8860e5b05a7c491600b2abcc96735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65615063044346cb76dba4a1a902d6c20be024b843590c20ab6d0da23cdac56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef052321d5287e387ac68afd04b64ca4efa329c4a2dc63869c51b56be4c37e28"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output(bin/"overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end

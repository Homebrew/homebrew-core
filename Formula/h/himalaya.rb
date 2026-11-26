class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "e6843e062be203d6c97b392f4f4f58844c3ae16f42849704727029e882274e0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0fce62956ad39ea76c99df35da0e3301360686a056e57d5c09e89cb8cf48a0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86cb65a5f5969464e2bf9a8f0ebb8104dd54f0fd758ad2a62d5811f97a8273dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76662dea6fd548a0ef1fcd53837ee76614420212181d15b2d1d1abfa5b7c4dfc"
    sha256 cellar: :any,                 arm64_linux:       "f4c7254c48119c47597734987681d23027c3213a6ce9b3edee983bda09c0df64"
    sha256 cellar: :any,                 x86_64_linux:      "4f371b48ca6debc1323bc92ad83da357cf031b93e918771bef33b39f473bb71e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"himalaya", "manual", "--dir", buildpath
    man1.install Dir["*.1"]
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    (testpath/"config.toml").write <<~TOML
      [accounts.personal]
      default = true
      email = "alice@example.org"
      maildir.root = "#{testpath}/Mail"
    TOML

    assert_match "personal", shell_output("#{bin}/himalaya --config config.toml account list")
  end
end

class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.4.0.tar.gz"
  sha256 "8da79b5e4606d609af4d995038e9edb2425466bc162f3b0f7f2b2f6133a2e01d"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df33d8699fb08d9cfdfbbb322ba4b2df6cba56359d982d9ff6f423feb3091fe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b026540dfe8c52c5db3405664cfb19cf95a16a7d85de4e5743a2cfafa8228bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a56ee4026cebc75860a012b1654de8ead3cebda64b025015b51ed96e77d2e8"
    sha256 cellar: :any_skip_relocation, ventura:        "159049ba4e19577a1aca768cd5deda9e4bc64de7a1912f1a279d27a5e6e7b5f7"
    sha256 cellar: :any_skip_relocation, monterey:       "ffea6b7a206c00128198baebd8190ce3ad64086fdd3ed2ba0015c973ed6a52c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "888762acb567adda23fc8125534da9e03508f62092a2f4020bf3889f073c7ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf393e4cc41dc9197704302ace85ba0b9b7e9bf5652538a545ac948733ced841"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end

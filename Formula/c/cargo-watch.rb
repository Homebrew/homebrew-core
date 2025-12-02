class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/refs/tags/v8.5.3.tar.gz"
  sha256 "1884674d19492727d762da91b9aebc05d29bdb34cdb1903cde36d81edbcc6514"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "8.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2498b5772d684e6b6021a83c7e4f5c390b089fb0e206a8fc000d2bb670736b6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e89525ad4d4dcff0e84930435fafab04934a7ed2cf2701e5747a9d953c9e9b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d767cc28d20886e772e0ba5ea5b32be862b609d79ddaf8f8dd7dfde4e1cbb8a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4f823712d892ad4cea59e3a9efb158f2aa03966df7f0ac970b9c5656476e9f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bf2377ccc8158f7eee24184f71b4d655fd6257085aad7ee18a0afcec3354c4"
    sha256 cellar: :any_skip_relocation, ventura:       "28a8bfc9784300c03deddccfde05dd22bb83d018c735275e2f2ea4df77a20faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e1f3420f8e56134c4c42400399b67ea3e3389490ed5fd6d5fbce8b3b93289f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bc56bac3a510bfeb102997b3bdba25b01f83dddf771b116c46ef101dc8df988"
  end

  deprecate! date: "2025-04-27", because: :repo_archived

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end

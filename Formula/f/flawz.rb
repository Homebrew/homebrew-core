class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https://github.com/orhun/flawz"
  url "https://github.com/orhun/flawz/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c5d30dfa1c07f5e5337f88c8a44c4c22307f5ade7ba117ef6370c39eb3e588b0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/flawz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "046a2a4a09bd81b23f85f689737a922f89312f70d3624f564930014e74d38e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97b5cd0db7f806b02e8b7a22bfffd3c3305780a218d558ca0053220205ba882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c66cdabc185ffcb53cb7a481ad8ef5866aceae91ae3519f6e8222bb23f874a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d41b1a2483d47ffff21a20a37b678d2b37ea25363010a592e5efe57ac9a5033"
    sha256 cellar: :any_skip_relocation, sonoma:        "0120b7ac67721ca6d74ec1fdf08e082fba851447998f54d698afb0a18f9f1d24"
    sha256 cellar: :any_skip_relocation, ventura:       "63ea238fa5329800901bba640c22d65b23d7971d6b15a4096121baeb7848c496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d9de54dbf400fb51a6b4a749309ee41df0e2a0dd0048c0ff73f349af5eafc41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76314b097693e33dfaffe268be3fd2dea5519df259c39958e6b6cffa334bfec2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    system bin/"flawz-completions"
    bash_completion.install "flawz.bash" => "flawz"
    fish_completion.install "flawz.fish"
    zsh_completion.install "_flawz"

    system bin/"flawz-mangen"
    man1.install "flawz.1"

    # no need to ship `flawz-completions` and `flawz-mangen` binaries
    rm [bin/"flawz-completions", bin/"flawz-mangen"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flawz --version")

    require "pty"
    PTY.spawn(bin/"flawz", "--url", "https://nvd.nist.gov/feeds/json/cve/1.1") do |r, _w, _pid|
      assert_match "Syncing CVE Data", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end

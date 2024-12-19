class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https://github.com/orhun/flawz"
  url "https://github.com/orhun/flawz/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c5d30dfa1c07f5e5337f88c8a44c4c22307f5ade7ba117ef6370c39eb3e588b0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/flawz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d9fc11d84d25830195e9ff2e2948ebcfe100365b6e9e4a87d1e8f4df5831616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c262ad502b668ddc1247d88148c60681ad589dbe985cb7bfe930b0f018edaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b80ac08fa94ce919947113bf419e77e9f90fffe30eb34bb53b4b5ddf973ae739"
    sha256 cellar: :any_skip_relocation, sonoma:        "413d100567192fc3159025d8bf445f7b5b902d3f80e6060c6f79f894dcd99aef"
    sha256 cellar: :any_skip_relocation, ventura:       "65ca1612a2345783cc1b7e2b071ab5789ee052aa1e323ff55a9f7974e5680f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917ae375e82d69e1c5952feeee931ebb6f2c18d48c0722ba06da19ebef69aa84"
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
    assert_match version.to_s, shell_output(bin/"flawz --version")

    require "pty"
    PTY.spawn(bin/"flawz", "--url", "https://nvd.nist.gov/feeds/json/cve/1.1") do |r, _w, _pid|
      assert_match "Syncing CVE Data", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end

class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https://github.com/orhun/flawz"
  url "https://github.com/orhun/flawz/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "641264999d2a5d662bc3d9c3994fcc580b92a2e9051c79fbcb8fdb2220924f30"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/flawz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c93092557f6fb166c0b746bb3e64abc4c15394d1fc90726219b814a4469b14b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96d0de83f22314aad4ab7c0800ff3ccb2ee25640ae821c94c281960f201c7b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0bddc1c8e9c928e93d485d194148c9e6d996beadf9c50b303b057acc6d9986d"
    sha256 cellar: :any_skip_relocation, sonoma:        "65bdc4361aa4173feaa4351dfb68ae2315c35dd83103d398c902df5815ace1f0"
    sha256 cellar: :any,                 arm64_linux:   "2c6c3e1564895ebdd2071af7b20936afaf36c94c0548ec5346e79588832d8b71"
    sha256 cellar: :any,                 x86_64_linux:  "8d4caff11b22a623428797da9903d523353151292db51e18531fd8edadcf2b76"
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
    output_log = testpath/"output.log"
    pid = PTY.spawn(bin/"flawz", [:out, :err] => output_log.to_s).last
    sleep 2
    assert_match "Syncing CVE Data", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

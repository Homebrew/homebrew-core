class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https://github.com/orhun/flawz"
  url "https://github.com/orhun/flawz/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a20fd49a2a69fce1bc248c40dc159569d8f5db9117e468af3c589b7dde3b16f3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/flawz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "993c8f052ec58ce4c1cee0c8e143713e3c15de025ccc614fe710da7d8bf4a723"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c1f3248134eeaed51ed4302fc2d6acf0a64d731055dbd2ecee5daf9259cd5a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0132d8b57a65e51e8996980491060d24acfffdf7dd0131783480ad6daf4f73df"
    sha256 cellar: :any_skip_relocation, sonoma:         "79fd53a760c4c3fbe63fbee93f153fca87b61eb0ef8ce63bc34ce4d92da88be9"
    sha256 cellar: :any_skip_relocation, ventura:        "d32236ed1bf4a1cdc8f27ae86714721bc45bac217696fe9fdfb15e6347fe06e6"
    sha256 cellar: :any_skip_relocation, monterey:       "17d99e6393c85a86f88eab245c1c05d0d80fa0508b7cfd7921945f4bb7bbc45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80f8d9c4b7537a3ac94e220814b473ae0a0810b573565c3c7e4ff3c6d6e1c080"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
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

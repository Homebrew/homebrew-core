class MdTui < Formula
  desc "Markdown renderer in the terminal written in rust"
  homepage "https://github.com/henriklovhaug/md-tui"
  url "https://github.com/henriklovhaug/md-tui/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "be1ad53a3291165b80e6eb14159dcdeddb206ce299a89b3235a5c1fda766890b"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ca30b120aee897ab51ee4430901426ae9e4ba05f9fafcf00f2a338cceed5320"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a955792a3cd55bf6745274cd05a683cbc693f47af6901b59b12d6882e7f05f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "811e9845558003da468b26dc4b001fd9d83a4e4c70357938acb8931bafdac81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "580b11e479088f504714e1b48cdafec559f6e65045408807f2fbb08a36bb6138"
    sha256 cellar: :any,                 arm64_linux:       "0d86897e9c4a8167f74a8c4b57a37be5f92599e63de122343e9611e762fed4f3"
    sha256 cellar: :any,                 x86_64_linux:      "72778804f7f21c761af098eb595e8356a5051d2156ab9d1e90ecc8f9e2873118"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"test.md").write "# Hello World"
    PTY.spawn(bin/"mdt", testpath/"test.md") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "Hello World", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end

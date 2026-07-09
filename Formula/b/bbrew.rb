class Bbrew < Formula
  desc "TUI for managing Homebrew, Flatpak, and Mac App Store packages"
  homepage "https://bold-brew.com"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "c07595b9915355e05aeb4453935ca28b2ba9705912f1dd045b93967001dafc90"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0dd295f0ed0e7c47c08f041385a6f17511574f3edde1360473769ee75a30453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0dd295f0ed0e7c47c08f041385a6f17511574f3edde1360473769ee75a30453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0dd295f0ed0e7c47c08f041385a6f17511574f3edde1360473769ee75a30453"
    sha256 cellar: :any_skip_relocation, sonoma:        "f55195c051617763fcdc0532801890283fa160cfdec0c2480f28931058fe035c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1a9164d52e282c8f8de6ef7d55dced5dc3abe18505073629b92f4c313ddc249"
    sha256 cellar: :any,                 x86_64_linux:  "135714c98c7c26226893660fe003f0a0229d55cff51f04f234cffc2cfd69fb7b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X bbrew/internal/services.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bbrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bbrew -v")

    output = shell_output("#{bin}/bbrew -f #{testpath}/nonexistent.Brewfile 2>&1", 1)
    assert_match "brewfile not found", output

    ENV["TERM"] = "xterm"
    require "pty"
    PTY.spawn(bin/"bbrew") do |r, _w, pid|
      r.winsize = [80, 43]
      sleep 7
      Process.kill "TERM", pid
      assert_match "Bold Brew", r.read_nonblock(512)
    end
  end
end

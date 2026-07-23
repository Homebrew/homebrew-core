class Bbrew < Formula
  desc "TUI for managing Homebrew, Flatpak, and Mac App Store packages"
  homepage "https://bold-brew.com"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "2e22f351e9726128746a3f2f8591e9d1a2f525cbe1aca6b0af6a20f6f909faec"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4c3f513dc30dd1375dd3c65f6489143ced0a16a524fdd4eeaa976bcf3dce50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4c3f513dc30dd1375dd3c65f6489143ced0a16a524fdd4eeaa976bcf3dce50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4c3f513dc30dd1375dd3c65f6489143ced0a16a524fdd4eeaa976bcf3dce50"
    sha256 cellar: :any_skip_relocation, sonoma:        "96abe299c275d4e5876a1d9b91c58dd5fabcd9f2fe9d77e5e832ad4fc5a25a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2af56528689c162a158b7c403510a2565d632192a540e75da2c1887a6c847cc"
    sha256 cellar: :any,                 x86_64_linux:  "65aa8bcd1bf0dc292311ff01e305599adfb137fd238e8a4629f5603056250bc4"
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

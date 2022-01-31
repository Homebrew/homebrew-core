class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.30.1.tar.gz"
  sha256 "5b1ad1e23c10d38b85a27b87affa7275a1116ecab8fa36b7040bfbbbaafbaa4c"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c664b6fe9c2585c0d92ac52193d3a2713b3a68d72575ab127e1f56a283ef3505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5da9a1e462b36c9f8820347eb41019b14aa9803749efb4f896fa7ba1488e81e4"
    sha256 cellar: :any_skip_relocation, monterey:       "93e5c1dfe439b13eee010ff04c8c41d482f32f5b56ec172a271a0c6f9b878a0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a549ae07dd6ed4ea76d369658b038268fa278625c49d712f4046f4cb03e7a3dc"
    sha256 cellar: :any_skip_relocation, catalina:       "eb9c6abe162a03cd7c71d3b7f5f13222c077bfe099d2b6a931e5d3cdf8db0c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7d7dc959ec62fa967144c251acbed55d64cc22f9702dc6e403a1dd9bfe820eb"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=zsh")
  end

  test do
    system bin/"fnm", "install", "12.0.0"
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end

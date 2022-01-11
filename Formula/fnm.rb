class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.29.2.tar.gz"
  sha256 "dca05a18787945d3d47882223266185045f9d806f1bcd193d14774f461280e30"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29570693bdf0f2b7dc3e126660216b13d540b2d8a263f34ef2598d536746a844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce103b0afaf0c2f3a0bd99d0047b5a70dc01a2f94fea11026f951d077b8e7c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "df1c73e0461744d0fac8d7cad29a75e681440f58939e3ed4f1cd20895f12cca8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8691b496054008a60e8c2cd9b096fe39a91ebbd70aa8e7b6baa67ce34483e2ab"
    sha256 cellar: :any_skip_relocation, catalina:       "7fc6c132604886baf82e6f20587ad1c6db34e11acfbd6a4bb13418e8518b01d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "621c18f5695b7f992429cb1c998aa6991c35bcada5151784ce740ba568860652"
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

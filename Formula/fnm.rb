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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f75507058261a99cb3b90825b9ca1e2b967846f47625c4ca1ca880a3f03deeeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94a41849ba4137ee43f55940f33c45867ec9d9af59d270b7e7a0e341f245b5a7"
    sha256 cellar: :any_skip_relocation, monterey:       "cd3d5cdb57f2e8e3883ed209d59f600c0d41d393f9cd399e3b45f9b7e282c1be"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fe34afde78e84531c0cb29e1ff8b59cb23f5c09f8b5a0d4b019bfa0667a8db2"
    sha256 cellar: :any_skip_relocation, catalina:       "b51bf1e55a65a2bdf024c787b0f5819eb34ca3053df2b43abf4dc30f7f889908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1033485d9733d35c1a831f8de04359a6a2d6ffa53225004c916bc988cbed04e"
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

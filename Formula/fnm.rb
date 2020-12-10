class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.22.8.tar.gz"
  sha256 "d294f1bd9f6fa75d53c5ba12283ca63a09812d4e3631aa314d781e50e8c9aec3"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "15e957f33a7474f9b41463f9de587db55fc2ac2c8ed7a9d120c108207376b763" => :big_sur
    sha256 "785aedf913a65e97029e2bed1c3e52a686d3707245183dbee84056ef6057d3da" => :catalina
    sha256 "8622fde031ee84e1ecf498250962b2be3972b9f161999e15ea64f50299b7e597" => :mojave
    sha256 "fb445426396192450f9b99ab43e798fa3dc18432ad25990d7b1c2ba5163783ad" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=zsh")
  end

  test do
    system("#{bin}/fnm", "install", "12.0.0")
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end

class Frum < Formula
  desc "Fast and modern Ruby version manager written in Rust"
  homepage "https://github.com/TaKO8Ki/frum/"
  url "https://github.com/TaKO8Ki/frum/archive/v0.1.0.tar.gz"
  sha256 "2e9e35d7077f9bd3684a86887645516c5e0b5ced54fd78e2a2137cf2bbd94f09"
  license "MIT"
  head "https://github.com/TaKO8Ki/frum.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c504c4c04a3de5d20f765b7ebbb52b108a623fa4cda8a810e870dd12ee756d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "96a6ceaa6e60dba09a0ab0440fb57cf9adccae016f62ad5cba90f7c885bcf38a"
    sha256 cellar: :any_skip_relocation, catalina:      "d8881e709692489994009e29f63584a45fe7a2db6f2a26655438c904db1578ce"
    sha256 cellar: :any_skip_relocation, mojave:        "8d0206951f833358562a04282c8bc58e1e9e5dce2783099c4b62e60dfda822fa"
  end

  depends_on "rust" => :build

  uses_from_macos "libiconv"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"frum").write Utils.safe_popen_read(bin/"frum", "completions", "--shell=bash")
    (fish_completion/"frum.fish").write Utils.safe_popen_read(bin/"frum", "completions", "--shell=fish")
    (zsh_completion/"_frum").write Utils.safe_popen_read(bin/"frum", "completions", "--shell=zsh")
  end

  test do
    available_versions = shell_output("#{bin}/frum install -l").split("\n")
    assert_includes available_versions, "2.6.5"
    assert_includes available_versions, "2.7.0"

    frum_dir = (testpath/".frum")
    mkdir_p frum_dir/"versions/2.6.5"
    mkdir_p frum_dir/"versions/2.4.0"
    versions = shell_output("eval \"$(#{bin}/frum init)\" && frum versions").split("\n")
    assert_equal 2, versions.length
    assert_match "2.4.0", versions[0]
    assert_match "2.6.5", versions[1]
  end
end

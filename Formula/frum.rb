class Frum < Formula
  desc "Fast and modern Ruby version manager written in Rust"
  homepage "https://github.com/TaKO8Ki/frum/"
  url "https://github.com/TaKO8Ki/frum/archive/v0.1.0.tar.gz"
  sha256 "2e9e35d7077f9bd3684a86887645516c5e0b5ced54fd78e2a2137cf2bbd94f09"
  license "MIT"
  head "https://github.com/TaKO8Ki/frum.git", branch: "main"

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

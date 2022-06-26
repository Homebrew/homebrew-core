class Frum < Formula
  desc "Fast and modern Ruby version manager written in Rust"
  homepage "https://github.com/TaKO8Ki/frum/"
  url "https://github.com/TaKO8Ki/frum/archive/v0.1.2.tar.gz"
  sha256 "0a67d12976b50f39111c92fa0d0e6bf0ae6612a0325c31724ea3a6b831882b5d"
  license "MIT"
  head "https://github.com/TaKO8Ki/frum.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6b4e42c48ff1381587393d6495921f2efb48843b4b4d7d92ce58bd65eaa576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b12d32db1a4e855e270187a4408a04d07910a569e36e53d3a7117b4f8ab0ec21"
    sha256 cellar: :any_skip_relocation, monterey:       "a7171c8633b63aa98c0ba9a59d94153574fc55122d7832a71fab2e4a6191cf69"
    sha256 cellar: :any_skip_relocation, big_sur:        "450a3b50d33857da4162dd71c43747088f9bb48f91267340c2e0f84fcc388277"
    sha256 cellar: :any_skip_relocation, catalina:       "00c21c236c923c435f6345fb3671ea1357332bb31fb2b33d08154f05b5659f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789664a6d8d6f4544fe2693a48b75b7b6fd832ed7685ab6dc6fd306a9b3eafa1"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
    assert_includes versions, "  2.4.0"
    assert_includes versions, "  2.6.5"
  end
end

class Frum < Formula
  desc "Fast and modern Ruby version manager written in Rust"
  homepage "https://github.com/TaKO8Ki/frum/"
  url "https://github.com/TaKO8Ki/frum/archive/v0.1.1.tar.gz"
  sha256 "b1227899d7b49c478cc56eba6c0e36325dca34e49db096c1a6fddceec5b0b9b9"
  license "MIT"
  head "https://github.com/TaKO8Ki/frum.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a412cdf7a3bb3da3e092d68e3bf5f742439f5325b9938ca97caa4d9027c9c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5caa257bf4b00da8d4000219f0aafd402c513f738894265c7b470d7add8acc6"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d503ffe8dbb3e555bbbe6349f94c799f0b572527ead94010905b76b732b461"
    sha256 cellar: :any_skip_relocation, big_sur:        "22742696bfd99efab6ba483134f00c8ae3316213a7d9e03a3b21bb2f20f2c984"
    sha256 cellar: :any_skip_relocation, catalina:       "8287568e2d549cf13620b70f2d3b1a40e1e68b82c91fbc6a26e0ec01f717b28a"
    sha256 cellar: :any_skip_relocation, mojave:         "24d6362695e8559f302e48a189e0b334b9480ddcdef845a93d07d2a743f03b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab5b0c5456aceb386de43ff1a378f1cc23c2b41e01ac7c0c8ae2266c398ee6b"
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

class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.36.tar.gz"
  sha256 "9f97100d93c8e0c3053ec97347cf72ca6cf8f64f5c48076bf41874c863fe5e27"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f753fcd3b687234dd596b80b5fe99b4a13574f2028de8214f2ebc4c48e91983c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "142fdb7d1da7c043b3971979e28f1e159f3231107decdd43feab716377ec6c95"
    sha256 cellar: :any_skip_relocation, monterey:       "08094e8b69acfd4cfe98c07a29fe35a4d5fe0bdf78c41a7714d8dbfd8c5f1ace"
    sha256 cellar: :any_skip_relocation, big_sur:        "38ba429dc7eb515ca232ac650597ce2017000aaa3e13f4d45c5495cdc9e5a1d9"
    sha256 cellar: :any_skip_relocation, catalina:       "45a366cc7092185f241f1a9caca62bc762c402503ee89ba7c0c494e9891a99bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6431c7abc5680ea46e08828565a98117d205009310a7612e9b27386b140a62e"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end

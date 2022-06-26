class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.4.tar.gz"
  sha256 "9dd289e9a5d932adb6d18fdf9f3758d88eea96d2faaaf0bc86e8583bde0e9eb6"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc65a6008da03a269d4e59c58a73474850c78f71bfb2efdc095737f9c7c5851"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ccf273b71cfdbb92fc72a17f96996c1db77146feed171645c606cbc3b2b62c3"
    sha256 cellar: :any_skip_relocation, monterey:       "a4c710c4133fb06d174228f1babab2a17d2cc7001c42beb6c7e2cb37ab3f1593"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b6f31784f25f8a6c684bc8de51a1a458455b0c915272d19c41735204ef263f6"
    sha256 cellar: :any_skip_relocation, catalina:       "284cb3ab15193f954feadfdb3b8f607ba694c440e43272b3f1cf90c663853808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1187d9d314a56742c8edab413386365d0dc70e1515b2caebeaa1e3f6f9df19"
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

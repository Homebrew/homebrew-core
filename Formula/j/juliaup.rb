class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.17.19.tar.gz"
  sha256 "5bcc9d9145e0d60d47aace5104805f6a21cab75ba19d8cfda88e1b7573291c7e"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "124719225451633c8388a76501cc32a5d401f06d1b21ac804d04c1daab9231b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dad7c0608bb8e22d61de78a207ce79f74b41790dfd9291dd702dc239e825ab1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87736debfa797f45c848d407d861b2dc7121654e81a9cf03250bce6b1c288e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a2b4b9859f51aebafcfa5d2301e609e820d38713826814b18be7040d158638e"
    sha256 cellar: :any_skip_relocation, ventura:       "102798492a832de134d646511331b043f51fe3c32fc31bb3c0dbf98e0d1b58b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50726ad6aa8c3a2b97ac85eb1e116a4c8a9870d8ac6fde7e9321684beb8b92f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729ff8e288917edca87e6a4c0b9b7077be3ede3cba8d2028185c4897bd5d96ad"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end

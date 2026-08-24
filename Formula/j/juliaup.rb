class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "4d52a3827091c0e75ac05040fd22fa22e3f34c4ed4370440fcbe717ccb2f09ee"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e518e94b42e5284ed5be6630c983dbc8856a673045784974aa15fd9a740133f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f84edcb9ebbc98656bb200e231994fa9b4a52012b618b0c384b4d02e7d9890bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293ffdc2ebbda7f758ad2ce54938de296af66ff21653d5eac0646a6752ee7b74"
    sha256 cellar: :any_skip_relocation, sonoma:        "d021c6b88afb82636f4797d3d9cb648a2343c288e98ca8cfacc837e78c0dcc3c"
    sha256 cellar: :any,                 arm64_linux:   "c30a1daf87fb1acc4f4b4434b36becfaf6c7c8999b4c26b8fff3ce58cff58c37"
    sha256 cellar: :any,                 x86_64_linux:  "fa91179fb2a2a9f2c51037e599012aeb0930febfcc6c42cf44d105e480307c3c"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end

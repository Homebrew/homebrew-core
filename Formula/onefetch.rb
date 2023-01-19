class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/2.15.1.tar.gz"
  sha256 "53b1c3acff1e557d3ff9f9a5f6ebbc1a6a5748912a6b96cb6ae0e35e9b5954a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f1a30918f552243064de48d676cad0b42353b8900442c4767aaf8169e6f72f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a53e763435559e4d49a7c151b873f8ecdbc01745d0234e19c4b4203d4d194a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe975449c82a21ec7e4ff5331656fb437861c1c78c186fd7a6842fb86b562c42"
    sha256 cellar: :any_skip_relocation, ventura:        "2118047958912a722ad2b05b41a0e9e4041d0dc973f02042d7cbf3bf5a18cfc1"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc838300aa4c52191823aeff02ca82b9da9aa502e8534160208b6a4173d9a00"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8c266f7035e51370267d6d807636f9974b198bbb93d8411fd6f0bfbd84de7e5"
    sha256 cellar: :any_skip_relocation, catalina:       "6110c913a91bf796f2fa31e22078250a6a2babdd90e14ba434ee102b5f94d085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e1b803fb49c420337bc81479eae56a954d6b98c22aa3f5b6f0d3b9ab6c886a2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end

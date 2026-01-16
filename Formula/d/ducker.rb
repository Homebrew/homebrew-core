class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "835c7826d295c3e908b4d54a5581c0120b5149c578d1c65b6d4cf136f51fbd18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a21da8fbb0d4c6dcf47d44b67b4e5827dd804ee20c1b9a9f13bc28c56ccc2d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea789e576cc657babd1474a1be5a111717201669d4e554817fbd02c98832b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0de08ab6a0e3681fac83f7beae93b96059b5ccbbef4532156106e808a8682d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee98a7e28e162ac10c6fe89755162a449d5dbaad2a84c8164864d60758679926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a748cee8c1a3e349e91aeaa2e482c1f74c124700ef99d30b552e179c6990fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923272320eb2513e3461d01bd8e135d676e8b716521f274b2ad736e535e2bf3c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end

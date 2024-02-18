class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v6.0.1000.tar.gz"
  sha256 "82c54d54a75b5a3f29d88d006a7614f61cb6464ffe78784f5f1e97cd6c6937dd"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9da0d0cbbd7875fe27dff8f607c5f70404eeb0b8902b714ab39849afaf5b835f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c98a1d8e7e33ec07ec56e5b50a16fad8c4586854eccbade91a95f7931f7174a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac4258180e27cec3ce71187e7672d659a1ed45d3e545dc5a4e0ccbaacdddb48"
    sha256 cellar: :any_skip_relocation, sonoma:         "490817803ffa27150a3cbf5fc9721dd2eba35013b6e9c5e3e75495b7f93a2589"
    sha256 cellar: :any_skip_relocation, ventura:        "ea96e95379624eb69f9f73d28eea1652a633d7bcacc4cb767bdabe4fbc6917f6"
    sha256 cellar: :any_skip_relocation, monterey:       "772bcff14878b19c62ba776aecf4bc86f5a5f387273d06294e0649b122cebc1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd6da1c8731c014b43173d7d15e65b99a40cb4ee8ac5e6f8f709381e1c10fb0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end

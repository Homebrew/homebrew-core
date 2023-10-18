class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v5.1.2210.tar.gz"
  sha256 "df32c34138b4fc03ca03339ac3061488e87507cf96fe1aad625f876d27091284"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51d96871f0114366725fafc0314f45cc7b6b48723419c37e44ec547b78667c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8612a61a8880fe3dde1b8f3c553b1003f2811fac72fcdd5eb3340a53b13beb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf664743c7e1fde10e87ed95218939eadafc62989aec65a896fff2ed67a2f350"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f1880052145e0b7ff7948efe5d107a0521e3e1c9bd92c5b53266b931f1fb4f9"
    sha256 cellar: :any_skip_relocation, ventura:        "8ffce880928f84846f9e4057cb40df222747027f6cc4040ebc3a2100291567e2"
    sha256 cellar: :any_skip_relocation, monterey:       "95b4423cb1f63f6438acf1549057d86e7b96c569d26ffffffb528ec29ac6222f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713aed596295c9c4b1876a2f1fafce8260b55574d83692abc78e1d287e0d5637"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end

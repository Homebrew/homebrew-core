class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.2.1200.tar.gz"
  sha256 "0f0ab62c5bc85eaf440b4a68135253c7dbc1ef264bc32cead4bc0c1fc0b8d0a2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83874ad97ca2cca6096409522d706a658f279ad2742bcffd561451129af40be0"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe10cddb0b82266ac7ea6bc70b0a39088315aa0955bf60b87e8151871aeb6117"
    sha256 cellar: :any_skip_relocation, catalina:      "e48432109b4134c424df4a40627f665e654b1ef146212f691a0d05486f7a404f"
    sha256 cellar: :any_skip_relocation, mojave:        "2ab121297b15a9c46b97ec0fee1c35e45fb44a2a1149fc285eae50f2b1d956f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56639ee264f9d05efefd60362bf8b3982bd11f68f34dfc348053e16d7164330b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end

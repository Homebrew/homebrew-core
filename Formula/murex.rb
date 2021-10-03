class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.3.4000.tar.gz"
  sha256 "d96bad1e575556d710693ace4286c9a5ec840046b6aa2c20e3e2369b6be1711a"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83874ad97ca2cca6096409522d706a658f279ad2742bcffd561451129af40be0"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe10cddb0b82266ac7ea6bc70b0a39088315aa0955bf60b87e8151871aeb6117"
    sha256 cellar: :any_skip_relocation, catalina:      "e48432109b4134c424df4a40627f665e654b1ef146212f691a0d05486f7a404f"
    sha256 cellar: :any_skip_relocation, mojave:        "2ab121297b15a9c46b97ec0fee1c35e45fb44a2a1149fc285eae50f2b1d956f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56639ee264f9d05efefd60362bf8b3982bd11f68f34dfc348053e16d7164330b"
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

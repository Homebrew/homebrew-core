class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.8.2100.tar.gz"
  sha256 "ba3fd505aaa8e8289f1baf0375d319b4f7fa9cda2ba4e6299d63705154f70406"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4648d48c028a86b0ceec046044b0521ce18d942d45c92efa3f268b6e1cc5c552"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc8a6b74aa9f84a92c037120a58eda2d26a8abceaa6ed6828998792149ca35ff"
    sha256 cellar: :any_skip_relocation, monterey:       "6a20f5e97bb0c70b329c19ee538587f21d2e3c1285108906f5df9f0d1a794bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5a8e99d1c253c6cd5ee653e9e9a0892a105910a0f4ee8e200fe936d0c3d7dd1"
    sha256 cellar: :any_skip_relocation, catalina:       "3c2218829bb98676fe88040db7133f1e033b1a548aa588f857baa5da20407b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b975083e678808c20dd26c3531ff5490cd3e8a43e4c30b71dd0c85dec12d4db"
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

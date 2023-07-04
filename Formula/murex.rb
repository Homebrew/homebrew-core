class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v4.3.3200.tar.gz"
  sha256 "3b03acf2339e32d83704db190c2cb34fecb9a941ea8b4ab4ac32ba8a33d75f46"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbf855673718f81d91bbaed61f17c4e8fee7f3458f3da6eb663f64879c46014e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdcbfc0a6740f02ecb0dc4c1c8ea3132a8908b53676340e46e55cb0856742612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79037e3c4ef7f5a8157ddf21571f53ca13f5aad5b10843695e0165630ec3fb31"
    sha256 cellar: :any_skip_relocation, ventura:        "ed203fc05eb568d9bd11866d8a8bd654f53ac5b8db6082acfe5205016d96ea8d"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb38c868f361019e1aa197e5c1ece2379152b2dfb0414606cd8607b4c6278ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "672bc5806b4730c78803c30795d0cd1cc83f5db3df4c7829b545e1826f11cd61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3a8141c39040ad303d656f485822d7d8b7be54634560c651fe834053d0737b9"
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

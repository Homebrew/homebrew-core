class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.14.1.tar.gz"
  sha256 "8a8113c0a1325785b212ed59410869bdea30ca2cb7400f95ebb3fbc8689eb6d8"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba7fb1490f6a8bb5136d465a0ab60129f94d00ea996fa246214816e84a7fcf50" => :catalina
    sha256 "13eefbaac25770a6d26e27bc1e061e6916ec5a258e0bd74c6980cd22b12ff121" => :mojave
    sha256 "f17ce74f44eb978941acaf715849399ddf3e154e4425ac17b020c6da59e63af6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/elves/elvish/pkg/buildinfo.Version=#{version}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end

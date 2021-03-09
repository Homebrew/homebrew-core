class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.15.0.tar.gz"
  sha256 "761739307c68fcbc51fd46c052c0a20ae848a30dba1ce3fbb6d27f99672f58e0"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79c48f95ff206c058f77401f776ca9696d68528eab1e1df26023eeab986646f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f94ee1690a4e64a5d8d6e3bac2494f8a1936ca9d9e3dece173ffc1e870e9a19"
    sha256 cellar: :any_skip_relocation, catalina:      "5699b736a32e20ce52ad1ec440af26cb409be9bcb09512d82939d3ae743a51f1"
    sha256 cellar: :any_skip_relocation, mojave:        "f39264950f60b3c7aeac77f179818d111ceebaea86f1e07cf914ff035d524d17"
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

class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "a6cb0153689d71fabc17496c6fc2b8b7b04a9f5d8e1b4988ef526b314859bb71"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f57b4fbb605e1e89ea42b86bd1bd3121929a4e271e034dafae2624cd402c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8c18d8560e23ae9bb1dc0181214fd3a7b3a212a836eb9853cf871e7d2b89770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672b29b66b6d83e66a4be46a68ca8185c620a2e9fa97e6c9d99decd4d1d95e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c3deb6309a9e76a96559ee68424a49442ee559458c44c233b82970ea59e2322"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "844e84e570a3192f8a4dde918c017167b3a20301af4da51dc38bd1f7ab7182f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee4e642337f3ec7ee7999c3dc2960d541bd813e2f793036adbe26886ec4e373"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end

class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.19.2.tar.gz"
  sha256 "c14da2751a519f2dff82bbbf9eaaccf13272c979082611a67a348044476424d4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "999dfe1c8900c4a3c563b7d6528bc346e9f35ba5fe7b2b36ba217a5d6af39cd7"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ad7a1e73f2b2733d175be505a8c56ddeacbe0b5a9a7b52dae8043a8160ef73c"
    sha256 cellar: :any_skip_relocation, catalina:      "b17913838bd7486f00d30aeb75c291032df491617584931a4cafab10b5a4b064"
    sha256 cellar: :any_skip_relocation, mojave:        "3c85906519aff96a98c81325099d3f501a8b91f54a4318ad365ba0dbc4b6ccd9"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end

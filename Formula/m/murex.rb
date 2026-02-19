class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v7.2.1001.tar.gz"
  sha256 "264a1b3ffca3fce8d8c1b0757e0498dc544fd5388694c405c6e4e42c6f87a82c"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3193c6beaeec3c1fe73f4248f0a805441fc01887da904b9c8f7c240dd1230bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3193c6beaeec3c1fe73f4248f0a805441fc01887da904b9c8f7c240dd1230bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3193c6beaeec3c1fe73f4248f0a805441fc01887da904b9c8f7c240dd1230bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "29d298fbd80b86cbdc2c095152d0395363c624e0a13dee033026506f2c21f108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f832eb214eb64fd60640fec5889c3b4458b0d68c1ef05616aa3889f315f29d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c08cad92194f238c4f3e5e7176a395a1cf74de294ea03aac04e2ddc29176319"
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

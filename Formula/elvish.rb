class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.18.0.tar.gz"
  sha256 "f4635db90af2241bfd37e17ac1a72567b92d18a396598da2099a908b3d88c590"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33e1bd7c5b826d749e9d9c5230061a750e99c1412a0eccd240526442d161de96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beb963831ef475de4031c539af501109a1d3feb4da3354abd2ade85ffc50ba79"
    sha256 cellar: :any_skip_relocation, monterey:       "322407431bcee76924ecee9f066d6aa15e6f474b73cf85263cd90e708087394c"
    sha256 cellar: :any_skip_relocation, big_sur:        "27500b6c67ee49bc28c2c52c46cd52a8e50f37f13f7a323057d22fbbc6522dd7"
    sha256 cellar: :any_skip_relocation, catalina:       "e388fef325ccae706bd8d1e5807bd90ea60d3067bd386f1343f9f59e6e8afc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908e3198e823605e9704f43db9a34e201f6ca7481f2adf0f5b78abd63777d50e"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end

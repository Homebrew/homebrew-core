class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.19.1.tar.gz"
  sha256 "4ae99be96a717156b40fa79a0571f320c9b25ecc2daf41c0f79c63dcde709d1d"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af6012cc93be7cf21ecdfa132b29b97a96eecfeee7afed1e3c7eb2e4b622866"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4bc627ea21a6e84823cc414d5cfdd21b679d3f5216af18917906ec9ff89b00f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dae041997cd32fec7b94af047e8e26423a6efc2086baf19c7091a855a53ec9a"
    sha256 cellar: :any_skip_relocation, ventura:        "d1cc95b2a448301c451d71fefee63ef6c028290e752b8e9454881cfa566e6bc1"
    sha256 cellar: :any_skip_relocation, monterey:       "646a7532bdd999afabfebd8a6b910fc67cb0cb04f098fc48feac14c51f43c7ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "14cdc016135c48332a59487fb5633f9fddc0bfd2d6453bc0bad475f1df84df11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4874e45492907e669de9bce4b817faea8eefbcec1ebd41491249e318bc618fd5"
  end

  depends_on "go" => :build

  # patch version info, upstream PR ref, https://github.com/elves/elvish/pull/1666
  patch do
    url "https://github.com/elves/elvish/commit/ece4f886fd2d0fd48df004f3c1750e6c37191173.patch?full_index=1"
    sha256 "c8a544ebb0337c8060fbe7218759fd2b2fbc8744daf4b6828fbc7df13fb92b05"
  end

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end

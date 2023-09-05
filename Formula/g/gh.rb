class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.33.0.tar.gz"
  sha256 "27e22a8e637501ee8e9d45c702dbc5c5c559c2a4fe59cd3d807e075cdbefddd2"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "980f985884168b4fcd88a00642de72011668ebc379bc4c8177bedb6efdb1ca39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ae02d5d654880e092e12fd47be491744dd17358d21f37ef29e26ffe3dee2fa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6be1cc79c42a64887ad81fd1c12eaa1740244faf7a52290878dd5d02cf745ba1"
    sha256 cellar: :any_skip_relocation, ventura:        "2400551e31fbfe702dce5bed64e686c774be60de641e359bbeae85f1d0ff0d2d"
    sha256 cellar: :any_skip_relocation, monterey:       "11c6519793bc2ffc8e87ba32cbf76d701d7bfd6b8ea438194d685aa25bf8383d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0dcf951635595d426d28a8688fe47837f9135f651fbc5e6315b8f74d3cfd019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "685bfd405d2b75398ad906e53dd9e1065c9195a343cec7072c2698036649cbcf"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end

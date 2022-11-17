class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/v3.1.0.tar.gz"
  sha256 "34653a6a45d49daef10db05672c9b4e36c3c30e09d57c3c0f737034d071ae4f6"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f6946f7740e007824512ee1f7e6b8e49620152eb97973d1938cac21ac7ab47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f331bfd82579f2356b72722d8850035d5905d707d747f7a1b63cc5e53abd71aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "075fc4add6d1783a3a971471c4b79c75c90cbeae13b3c29165d61df28f5094ef"
    sha256 cellar: :any_skip_relocation, ventura:        "f04d40ef95fa6ae6374eecd1e924fc3ff51929c57562d1265fe5838cf32cac02"
    sha256 cellar: :any_skip_relocation, monterey:       "2f4614b05b44e912d099a47da1ccbcbfd95c0126ffe1e0247ecda2068ee54afd"
    sha256 cellar: :any_skip_relocation, big_sur:        "13121cfeda4cbddb26c71c5684b3bae1666dfcd1f424b6bc3cac4c772b8aa853"
    sha256 cellar: :any_skip_relocation, catalina:       "6a31fc46b6ffa519cad9d81796188c6e60cf902496ed563a111871d157e229c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d5c2b7b433cc529576311cbe9b9ef9d8060f50abbdaf21736aaf5e6f3e450b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"exercism", "exercism/main.go"
    prefix.install_metafiles

    bash_completion.install "shell/exercism_completion.bash"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end

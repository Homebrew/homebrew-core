class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v14.2.2.tar.gz"
  sha256 "82ad26267f126b76fd212cba82faacce9b1018d830c082927d83babd6da01dec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19301e881a64129486ad1d00eb6d52c1f0dc5bb815cea82e85904c3a68a25a61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c917cd01672221b501624f6156db5bebd45b8928eedd3349d05a566b0966d29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db68ccda4241249f0772a19cad83430e159cd891e7b6e94c912f77b434803b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e20ef7524e7074ab4d351f4f5cfc49d25f6afeb28fb2a18391e8cb88979af2"
    sha256 cellar: :any_skip_relocation, ventura:        "53cbc7bc17679b79e3b134f748ce40adc9dba9c1fa50a06e50f53c26e251b67d"
    sha256 cellar: :any_skip_relocation, monterey:       "26187235f7b59152338bf51becde392f0da41789d952cf8585ad48e98f753cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da10016ed00688045c6e3706badd063dedd6bf0599b37de081ce0f14870b2664"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end

class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https://github.com/sinclairtarget/git-who"
  url "https://github.com/sinclairtarget/git-who/archive/refs/tags/v1.2.tar.gz"
  sha256 "06c341ecbc81a518664b8facb49891fb94689da37c83978ee21a02916c0dbed3"
  license "MIT"
  head "https://github.com/sinclairtarget/git-who.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0abdd4cfd053b1f82f56a5fd94c2a33edb5539aa2224293d6476d920ef691093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cc6b40cc76044eaa90effece5d9dcdefc2240db4fdb73ef89ad56bae49664e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cc6b40cc76044eaa90effece5d9dcdefc2240db4fdb73ef89ad56bae49664e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cc6b40cc76044eaa90effece5d9dcdefc2240db4fdb73ef89ad56bae49664e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f4259af8170e7a3b9586b623fa38cc198e1404e02c23f9d5fe57da2efc8e695"
    sha256 cellar: :any_skip_relocation, ventura:       "3f4259af8170e7a3b9586b623fa38cc198e1404e02c23f9d5fe57da2efc8e695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6de8d87eac553be27eb87b97dd562e56be6653edc1b15f0580b7317a7e12ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8811cf655c04955970a6b77d3b004b9bfb91cb27c0aec9799ad0d2de2e1be21"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-who -version")

    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "git", "commit", "-m", "example"

    assert_match "example", shell_output("#{bin}/git-who tree")
  end
end

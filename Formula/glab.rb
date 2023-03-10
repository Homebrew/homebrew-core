class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.26.0/cli-v1.26.0.tar.gz"
  sha256 "af1820a7872d53c7119a23317d6c80497374ac9529fc2ab1ea8b1ca033a9b4da"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f40bfcbc4e1402c456d268b900c45d556ed14f0c5ace47f73bae1f1ee9a1a0ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc461b0469f87205a69052ba91e89bdd9cd92e8dd2402691f248c20750b1c38a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f4584e799ed7e597c66a26f9ddb9cb0d8acef20e043f9569bd3cca02a17dfae"
    sha256 cellar: :any_skip_relocation, ventura:        "9b22511978208d021d4264607b2d714aa24f0f047947850e72fbee13474ec07a"
    sha256 cellar: :any_skip_relocation, monterey:       "91ac9fac41ac358ecef0916f107f1b954223b4062d230ea5821efdc5dae06d38"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f87092ccdc358e684fb273105b12b7263b9c962d5cf066a7f8d112168c5fffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "963a6d9f6edaf7ddde938a124397ef98d14bdf523ad10b4231087f6df6af2477"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end

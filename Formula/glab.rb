class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.23.1/cli-v1.23.1.tar.gz"
  sha256 "62eb94245aba3211ea10a5bad6a350d5bc77e1a44550470240f7a1dc0edf73ab"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "554ec290b218a792f6a9dc92aae2ae07e1bf75866e5a9692082ad85ed3e785ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85be6d55b367e8ec9c0e76b54890762d6c9706fd75aa5b39207ea3e967bd923e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41fa0e14f613d1cbfe01700a65c65f30a4b43f2c99e564ec83ef07a494387a95"
    sha256 cellar: :any_skip_relocation, ventura:        "54bb6b7d6d967200e4639ef3886d8a0178d2b798ec9b51bf0a2c497024f20037"
    sha256 cellar: :any_skip_relocation, monterey:       "36de37f5d3a92c4e40333017653095be16eac1611bdf4450729b145c6e7b3157"
    sha256 cellar: :any_skip_relocation, big_sur:        "89730fe4b38d7e9efbcc7cfbeeab32e3ce80a3302cf56556e2bca185ef206e62"
    sha256 cellar: :any_skip_relocation, catalina:       "20a17704b7feac3e972e85fceecd844ec765c5a123727dd38aaaac3980e0fa43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e2558a21a45a846efd44ad07e5fbb2a04dc8fb0e916e3dfa352bfff6ec7bc6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end

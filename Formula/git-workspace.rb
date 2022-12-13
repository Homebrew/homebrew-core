class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "59876001a048eb46cffe67ad8801d13b3cfc5b36c708e88eb947ebef8f3b8bf1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcb1744c2eee23acb5cfb36abca49d08cffeac862b73aed414d794ec2884fc95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a4f6621eb0534c90bda949e19d30a3aac05c05f0627e29e08aacf5a975ffef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae0adc0d535f78b96bebad610cf9ec4eea72565bef7ef79aa3d80905ad61a2b5"
    sha256 cellar: :any_skip_relocation, ventura:        "aa94a845a627e90b4bf76a148f80e1ffea677751e438123ecb591396f861eeae"
    sha256 cellar: :any_skip_relocation, monterey:       "452043f5336bcbac3693a7e45552af501b2ba6df9878d88b21ddbd086971d3d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7f6ab955899b4bf9290ff793399995fd5a298a85943669e845864d1615060bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e151fbcb03e3e4eeb7bd02611c087e732778a11c25990c0575620f4cc554fb75"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system "#{bin}/git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output
  end
end

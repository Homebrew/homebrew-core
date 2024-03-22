class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "807eb2e3340ff4b509e8cc3157f98ec4550ecf0a8581da331e60f0ce9b43c847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f6feb69e964100c4da75beb507c1077d781433bb9286a73a37e177866e43b01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdea6d2b69c391d699b6f113acf00be2cc33fbe9e4b3cbbd440b45cf77e6e735"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd114394ab506e5bd77880e9df3bdf9031cb7f96608acc59d64eafa055c586d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7056b84cb17ddcd8d11aa30c4877fbdc5d92bd037a075672491123ab50f4d95"
    sha256 cellar: :any_skip_relocation, ventura:        "035f867ed6cb4d640aa3a950bcf1a691bd307780d03eed590d50f9f3512025eb"
    sha256 cellar: :any_skip_relocation, monterey:       "a0792c61d78e60194a5de82091e01ea33c4eb0093ddc85e92b7c9beb37641859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec18f6b04d66f1b54172e63c31c7f9298b8aa43a2da448f5135bc90f1317017"
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

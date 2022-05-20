class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.1.tar.gz"
  sha256 "5f3313c3f226cdcb374631036b1187cfd52a857769ec254ac659098082a4e94d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "855852c5405d0246e2adcaaa26cad7c06f8c519b6f39305dc4406d47f68257ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "855852c5405d0246e2adcaaa26cad7c06f8c519b6f39305dc4406d47f68257ff"
    sha256 cellar: :any_skip_relocation, monterey:       "9f3476c0755cd6dae2943a47c61f33ec95157db8bac12790174779f24aa23450"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f3476c0755cd6dae2943a47c61f33ec95157db8bac12790174779f24aa23450"
    sha256 cellar: :any_skip_relocation, catalina:       "9f3476c0755cd6dae2943a47c61f33ec95157db8bac12790174779f24aa23450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0546fd797f98f5190eb5e9ee294cae561bd9cba115e0237fc66bf35f9fdea4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end

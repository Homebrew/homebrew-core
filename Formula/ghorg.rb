class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "0a4c7f8051d8351508510148e01c965a10490d97362b9c14407d0d19d7fd7778"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c02619092bfdc6fdd64a9f7593cd5f654d51b632d265133ab4f54165b89248a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e481e33fa2cfc5023545babecbd35044fa1cb82f5d0966034848fc98029747b"
    sha256 cellar: :any_skip_relocation, monterey:       "a1250ebd3d16be9928eb51480de8729a3855ac985312066113a85f1e74b57006"
    sha256 cellar: :any_skip_relocation, big_sur:        "d29fab7ecc4a1c870c5a2cbdffe31d909a2a93fe0fddb2b42e6ada1549026143"
    sha256 cellar: :any_skip_relocation, catalina:       "f262b941ce2df0faa9920b1679284b0749aa72ccde94e8107c3bbc82d6d326cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb69d590574dda2d0f88365918143cfb825d88f73aab1c9b34d5338ae2a3b86"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end

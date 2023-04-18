class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/v0.26.tar.gz"
  sha256 "ccd7afcb825eb799bdaaaf6eaf8150bbb8ceda02fec6c97f042b7bbc913a46fc"
  license "MIT"
  head "https://github.com/naggie/dstask.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d79ae69accd7905d73e6f15fa3fb0a6f05ea23bfd7b7333ddd7839d522e285e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb785da84d172ec459b7322031e52d67df8611a701020218a03c91b90eb1a890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4be4ac5744549c10dfb731337f312c4aa47e9ce103d46343c4690c8321882f0f"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a1e47af361d58a32e806b6d675a2257b12356bf54cefd6792790e50ec5928f"
    sha256 cellar: :any_skip_relocation, monterey:       "032acb245aafde4a1007a88c6bb19a6f3da10b3e6880ce41eaa8d96f89680559"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c491f3930296ca760c81cfb4577616aa6bc9a9120e49a301b160becca721a7c"
    sha256 cellar: :any_skip_relocation, catalina:       "ffe559741df2fc7b18b745287658d29acc84d854533dff5d2176e8453ad179a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ced7cf5c0d00d885ce99aea38e2be90d46292750dcf4e9fb1bc7fea9ce68b6c"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "vendor"
    system "make", "dist/dstask"
    bin.install Dir["dist/*"]
  end

  test do
    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    output = shell_output("#{bin}/dstask show-active")
    assert_match "Brew the brew", output
    system bin/"dstask", "done", "1"
  end
end

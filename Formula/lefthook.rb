class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a824e1e3a2426fffb50c6ad49b3761262df8dabdc371e8ca414af1b2b115bba7"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81a0841dd6ebd3318596c9d73d8e675d29439101986592bfafb123a793774077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba38813a512f92169d67e37a59aff474cc667154d4019b3635d3bb0129a694f5"
    sha256 cellar: :any_skip_relocation, monterey:       "0c9e5b24620618a6eabde324097bd0344044a5b2ad651885d357ce70b05b5de1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1adbd3210777d77a318de082e294d8118fffc3057a2472ac435a041a45e086c"
    sha256 cellar: :any_skip_relocation, catalina:       "5ac5a1642048341273704288c9294061283a8357c35ff6349c6c2bf97ee65af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d24b7a7de42c3ee5732815692d15b05f9e775da59a146fdb8ba48b877d26231a"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end

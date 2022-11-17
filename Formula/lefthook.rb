class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3fad1cf6eb315f10b40504666437a0bd8bf454dc575abe2dfa1661e7e65632b9"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db8e7b980598bd92da0a5202aee0dafb705cbf4d6b91a088b3e7e33a4696ddb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3fea3b0d967f4bc0a390a9981b936a6c28b0919cc45877711700d5429582b48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe0e0d6b08e8dfb5683a96ded94fa5af17b640d1ccdf9ec3498381d119731de3"
    sha256 cellar: :any_skip_relocation, monterey:       "1c826933bbc70100cffa90d2cbaef91f1e40e89a087c8b378746456d37c782eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1291521da1cf8705549ef273c8ca0a943cf108a55592675eb04693b15d27c641"
    sha256 cellar: :any_skip_relocation, catalina:       "4645dc7c140183772d97516185e06d065d51d5df0d2c0c172d8e712ba261ef67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a6c86e41f4d58d649ac0218fe7a7887cfdbf9c90cd75f6c02f52a9a1a704c6f"
  end

  depends_on "go" => :build

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

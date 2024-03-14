class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "7eb30ae87868a376a87a5ae5a812d26590e29f611c0d0c05606374c9ef62f5b8"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "474e7221a0ab38612c38d69e35a65d2e55908e6d78c3dee2760b0255a4c8f97e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fac1061224ce400156adb7bcaa01ce5ffffacd43d79309e393c8f38b690a6e76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7983e3598ff1d44e281eb41345df920b5b7b1edd5d499722a851c5e9f52e4677"
    sha256 cellar: :any_skip_relocation, sonoma:         "7778fe677a17023119d33e610b67d0777914e7dc1b8693a1a799e12232778fd7"
    sha256 cellar: :any_skip_relocation, ventura:        "62e0a44a4a85b3f5dc6300784d1ba663f7d40ee2dd29313a6d450446eb52a274"
    sha256 cellar: :any_skip_relocation, monterey:       "4b39c2264aec7e573a1bf75821ecce4ade4b74a2f00c4fd4b651685deb08a569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e93cb8861e2813f42b70eaea9c2ba7b279d277f85d47da057ccbb95ed5f86e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end

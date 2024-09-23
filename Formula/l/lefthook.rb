class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.16.tar.gz"
  sha256 "e84d8dfd84dd16b9e882196425a7404fb47186e4a9fb2ca234b675ebb20693e5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e87c7a2f84f2acc9116bdf0288f2d2d9e9cc3ee00ffc9f0c69f1d69e323fa24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e87c7a2f84f2acc9116bdf0288f2d2d9e9cc3ee00ffc9f0c69f1d69e323fa24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e87c7a2f84f2acc9116bdf0288f2d2d9e9cc3ee00ffc9f0c69f1d69e323fa24"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f716a390c58c1bd8516b0f9ab8877868972ea4c09695c31bd61b2d8204f4da2"
    sha256 cellar: :any_skip_relocation, ventura:       "1f716a390c58c1bd8516b0f9ab8877868972ea4c09695c31bd61b2d8204f4da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec0a06332f0b3ba82eadce5a536d8914f8e3385fe26de72af5b7edd146645720"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end

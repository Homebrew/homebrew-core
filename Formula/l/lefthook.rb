class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.16.tar.gz"
  sha256 "e84d8dfd84dd16b9e882196425a7404fb47186e4a9fb2ca234b675ebb20693e5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1ff454631fa0fa454378a851b27b4f9248cc0be0d8c0dd2c17d1d15bcfea5086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cecde163b0f88f8e86f74de8462c6d4ffe1e068a0e8669796bdc658ca57a985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cecde163b0f88f8e86f74de8462c6d4ffe1e068a0e8669796bdc658ca57a985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cecde163b0f88f8e86f74de8462c6d4ffe1e068a0e8669796bdc658ca57a985"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb866094eaf022c32ab74b1f5189f2ddef65ec617f85d9bd9ab9f59d387659e6"
    sha256 cellar: :any_skip_relocation, ventura:        "eb866094eaf022c32ab74b1f5189f2ddef65ec617f85d9bd9ab9f59d387659e6"
    sha256 cellar: :any_skip_relocation, monterey:       "eb866094eaf022c32ab74b1f5189f2ddef65ec617f85d9bd9ab9f59d387659e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb571a089bf086cc00b9a9f0fea8fbd0a0648e558510f11f306ec9f9443af1d"
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

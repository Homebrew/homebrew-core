class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.15.tar.gz"
  sha256 "5d77e73ec92335d76c1ab2a3e42ada2cc8fd64df3adf9bd38060de80289cdd6f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b10145838c60042237020570962ea38effe685d60d4b1844fc4a6062987c4855"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1adbd0ae437011c4904c4b2bba18857fbbc115def98db65dd47d8894c9abf94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f2b1e1cd37b010eb9f52ec975134b15b23fdb2a9d95f6acd3cc3969ddd2a4b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "60c1a81b5d21a81cce630a8a3e6476a3c696fa2ecb3ed09d42bcdde19d5249ee"
    sha256 cellar: :any_skip_relocation, ventura:        "c944375cd0c7c0604725f61b400f3bdc584f94058de9a485d6f614760c30eade"
    sha256 cellar: :any_skip_relocation, monterey:       "df3bbc975eba0440c10e0948f6cc7f41d1f94d62e76a748ec1cabdab7db25ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d50a7404b653dd4372eb8e84e366fbe4f48b70ede2c93757588ea19cbd7fb368"
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

class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.10.tar.gz"
  sha256 "01739e087ad698b6a18d7675deb67446b9f50bce000eeb3f1df1a6960d2cb42c"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4916475d32521f284080963ea362ef48668cb6ae41a1756c2791b92ff512484e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4916475d32521f284080963ea362ef48668cb6ae41a1756c2791b92ff512484e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4916475d32521f284080963ea362ef48668cb6ae41a1756c2791b92ff512484e"
    sha256 cellar: :any_skip_relocation, sonoma:        "37dd3bca85382e4707e77a10b66e4b478684dff0e325497ecf7f76fa00ee5f62"
    sha256 cellar: :any_skip_relocation, ventura:       "37dd3bca85382e4707e77a10b66e4b478684dff0e325497ecf7f76fa00ee5f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a85ab44b54b824ba16be03e8c28d3e7573ec85ddb97c4f2731878aaee85130"
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

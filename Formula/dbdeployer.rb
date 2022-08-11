class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.67.0.tar.gz"
  sha256 "70da71e86c21c8c807fa868f166c8d2a85878fb3412554549f8007e877ed8af2"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46f842d5395269d916358c1f1797e41b711e241288e78a24a71f92902b996ce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f16f86c752fc88620c75bf969e417fde31a3d3c27e037635a19edd058d6b7375"
    sha256 cellar: :any_skip_relocation, monterey:       "f886786c76950dcae716dd32502febbab390ffda21acd33d5000328361e1b508"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ec017aecc4e89cb7fac821ef365500a1365ec5722140ea78d6de778b923315e"
    sha256 cellar: :any_skip_relocation, catalina:       "4b304865d702b29f618768ef98080648a38d800a0236b39dbd8fb592c9c9bf22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e516661b28008adf9ddbf3f31c3a4f3d9586ff14bb03cc3406069d15171526a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end

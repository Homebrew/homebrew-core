class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "c406ff8c8a959f5de0730ecfd393c432587f824b86cc91979ee54e4e96b44ac0"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5daeabe93c5968be4e4be53e2d1b87b7cacc87c7ac25b9a8be3643a665b85272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5daeabe93c5968be4e4be53e2d1b87b7cacc87c7ac25b9a8be3643a665b85272"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5daeabe93c5968be4e4be53e2d1b87b7cacc87c7ac25b9a8be3643a665b85272"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd4f7a5f56aee0212ed974c4ad9441b8f800f57ef73864729dcd2641744f9de7"
    sha256 cellar: :any_skip_relocation, ventura:       "cd4f7a5f56aee0212ed974c4ad9441b8f800f57ef73864729dcd2641744f9de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88dfd175a7bb323ef3e1df32ab69035480bc0ffc1a34790b662141b17d9a0a34"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end

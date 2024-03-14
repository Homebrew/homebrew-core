class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "7eb30ae87868a376a87a5ae5a812d26590e29f611c0d0c05606374c9ef62f5b8"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1df3d07796b0f7ba93da7725c5bd2bdc3e7562b5c3b1c19d1ada60c366f67fd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00bebe7b8083bb5733e3870109171f9a0bbe24d519585b3e7f879b6644cb9ea0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "106cb74b7520e74fcdaa7825cbf163f7504cbb6118f6a3fe5e797f6706f01f90"
    sha256 cellar: :any_skip_relocation, sonoma:         "c63d82a00963fa9cd30105768e70c241f33a7f4101908522d6e4ae76cf9df223"
    sha256 cellar: :any_skip_relocation, ventura:        "6038b0b4fd8aa5c790166a16a2ec902f895916054e671eae3d8eff53319ae350"
    sha256 cellar: :any_skip_relocation, monterey:       "e32353ca0f16bd9a68e24298a1eeac233c3159a7a22249e6b695d73ecef81111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ccfe0c94810081fb5fac5d50f69e5581c6f8d66f10ecfd4b24b167f4c3e38d7"
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

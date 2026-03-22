class GitGet < Formula
  desc "Better way to clone, organize and manage multiple git repositories"
  homepage "https://github.com/grdl/git-get"
  url "https://github.com/grdl/git-get/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "82a24231bffacc0a8eaf50d21892ac6160f5f616cafccd2381b8bc9845452ff4"
  license "MIT"
  head "https://github.com/grdl/git-get.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "464f062000fe3f6e5525d2a5f0394b7b003a2f193a8312ffa3cdf2761223d754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464f062000fe3f6e5525d2a5f0394b7b003a2f193a8312ffa3cdf2761223d754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "464f062000fe3f6e5525d2a5f0394b7b003a2f193a8312ffa3cdf2761223d754"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c5a8f16dbdc56754b29b1d7d2f0d232726cf5edad2f50d73d9d0e300426e173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4c8ef23f41d2c8579c2ac1c4c8add8a7b5c8019c6fc8830ae616c8330e7ca98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56d77d08cf62f685e0c1084ee9f79a80b67464ebb51d2e16a6ccab0189e08fc8"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    ldflags = "-s -w -X git-get/pkg/cfg.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-get"), "./cmd"
    bin.install_symlink "git-get" => "git-list"

    system "go-md2man", "-in=README.md", "-out=git-get.1"
    man1.install "git-get.1"
    man1.install_symlink "git-get.1" => "git-list.1"
  end

  test do
    clone_path = homepage.sub(%r{^https?://}, "")
    system bin/"git-get", homepage, "--root", "."
    assert_predicate testpath/clone_path, :directory?

    cd clone_path do
      remotes = shell_output("git remote --verbose")
      assert_match "origin", remotes
      assert_match "#{homepage} (fetch)", remotes
      assert_match "#{homepage} (push)", remotes
      refute_empty remotes
    end
  end
end

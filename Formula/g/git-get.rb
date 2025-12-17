class GitGet < Formula
  desc "Better way to clone, organize and manage multiple git repositories"
  homepage "https://github.com/grdl/git-get"
  url "https://github.com/grdl/git-get/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "82a24231bffacc0a8eaf50d21892ac6160f5f616cafccd2381b8bc9845452ff4"
  license "MIT"
  head "https://github.com/grdl/git-get.git", branch: "main"

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    ldflags = "-s -w -X git-get/pkg/cfg.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "-o", "git-get", "./cmd/"
    bin.install "git-get"
    bin.install_symlink "git-get" => "git-list"

    system "go-md2man", "-in=README.md", "-out=git-get.1"
    man1.install "git-get.1"
    man1.install_symlink "git-get.1" => "git-list.1"
  end

  test do
    assert_equal "git version git-get #{version}\n", shell_output("#{bin}/git-get --version")
    assert_equal "git version git-get #{version}\n", shell_output("#{bin}/git-list --version")
  end
end

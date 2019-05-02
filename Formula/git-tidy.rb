class GitTidy < Formula
  desc "Delete git branches that have a remote tracking branch that is : gone"
  homepage "https://github.com/drewwyatt/git-tidy"
  url "https://github.com/drewwyatt/git-tidy/archive/1.0.0.tar.gz"
  sha256 "5bdae85d8ac4fe59305781846229017a8649d894f82ed9cba243ea1a534bd511"
  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=#{version}"
    bin.install "git-tidy"
  end

  test do
    output = `git tidy -v`
    expected = "#{version}\n"
    assert_equal expected, output
  end
end

class Gib < Formula
  desc ".gitignore bootstrapper for projects that use git"
  homepage "https://github.com/DavSanchez/gib"
  url "https://github.com/DavSanchez/gib/archive/v0.2.0.tar.gz"
  sha256 "12903d67bc6b3734b1f0841512c47e5e85609cc8b188d2f562f460a1c8ad8418"
  head "https://github.com/Davsanchez/gib.git"

  depends_on "rust" => :build

  def install
    system "git", "clone", "https://github.com/github/gitignore.git"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/gib", "rust", "-o", testpath
    assert_predicate testpath/".gitignore", :exist?
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

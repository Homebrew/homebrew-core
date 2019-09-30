class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v2.3.3.tar.gz"
  sha256 "57bbd5c5f24eab4d5eb5ab2dd9fb7b534afbfaf78d0c07fbf8c570b2fe5fae0a"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b6c99b8a4bd18131c01a2cfd4cc855140f28bb828f586c98d98b18bf686b1a7" => :catalina
    sha256 "4ac2a6391a16528f35127f88a52476086d8b62833be8afe2234fb99d23c151ad" => :mojave
    sha256 "0856de98e48b3ceedc567399cf08871f51ecb4df9e091e4e9aebb6437ff9c98a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "go", "build", "-o", bin/"kepubify",
                 "-ldflags", "-X main.version=v#{version}"

    pkgshare.install "kepub/testdata/books/test1.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "not an epub", output

    system bin/"kepubify", pkgshare/"test1.epub"
    assert_predicate testpath/"test1.kepub.epub", :exist?
  end
end

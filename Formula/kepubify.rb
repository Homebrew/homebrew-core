class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.0.0.tar.gz"
  sha256 "1207fa20b230f7cb178e8114eda90edea7728a8014f7c7a86c46a4b4bfb4d87d"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8665f772a9bad3c21234f6a561203100fc8b57263f16772f6f424a2d56846ec" => :catalina
    sha256 "5f2430c8953d3a47c828a41c9dbf60d5b1f6655fb4e887f5f61837ee94e67ad4" => :mojave
    sha256 "ae083de5a7ac78416a0b6aaaab7b5ba6b79cc4d10d53998a97a0a6cb792a5fae" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", "-o", bin/"kepubify",
                 "-ldflags", ldflags

    system "go", "build", "-o", bin/"covergen",
                 "-ldflags", ldflags, "./covergen"

    system "go", "build", "-o", bin/"seriesmeta",
                 "-ldflags", ldflags, "./seriesmeta"

    pkgshare.install "kepub/test.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", pkgshare/"test.epub"
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end

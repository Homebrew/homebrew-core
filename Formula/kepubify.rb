class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.1.0.tar.gz"
  sha256 "11b995d95219c2d6ac933d365d90e40d9f1ac79bcb9af619bb0128c6d64a6ad9"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc3fd81c4660bcddf8bf4c01da82bcb9c6e0c2424c0c3f849c31907f206a25a9" => :catalina
    sha256 "454818f988814c6c9e2933fa011d8813d35ecb4ab7bb1a62620a7c13a19f985d" => :mojave
    sha256 "5d525a149e3759d7860681000f0c7f5cef2bb5baca3025a27d9d5d28b8752c47" => :high_sierra
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

class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v3.1.6.tar.gz"
  sha256 "09b81eff1cf53fb184773cf289c1eee56c3354cf6e1efddb5e308566b31de69f"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e02509869a8df49f088eb41e66ed902666df38cd71b0f7ef7b84422b2ddea91" => :catalina
    sha256 "fa527fc68639a4cc54e28cac3423707c31f7d4b6dc2bce6109180ee8e8f98e9d" => :mojave
    sha256 "3e9bfdabc6bfcd290764ac61c7d118662e482baba0bf711d8542d3662c1527b4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
    end

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

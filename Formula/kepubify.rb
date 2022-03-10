class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.4.tar.gz"
  sha256 "a3bf118a8e871b989358cb598746efd6ff4e304cba02fd2960fe35404a586ed5"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c0ce08493ac1eeeeb0d6de786704c60f19865f46a2a83be25740d53fd9eda10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ffb2ca43618648f24f67a86545477330ef93ab1630cfb0869339cbc75fa420b"
    sha256 cellar: :any_skip_relocation, monterey:       "583fb07c1136c2a70c752672be635ea0f0a175ebc1f25a1664e543bae0719d39"
    sha256 cellar: :any_skip_relocation, big_sur:        "67afc66b3a4036cd114109971d797c52cb1f9c10b997b400968e287bd0f16e3b"
    sha256 cellar: :any_skip_relocation, catalina:       "f81cff74730aa1b35205f8c9d3fc7dfb6c8675a09bcd5b10fde9314de324a885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e1c3ecf95832330a8275b62d09d81810973cff9a3d54ebb549aaf48a5782ec"
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
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", test_fixtures("test.epub")
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end

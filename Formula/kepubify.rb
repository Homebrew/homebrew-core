class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.2.tar.gz"
  sha256 "f6bf7065ec99e48766f60a126590e021f5bd4fac19754ecb2d90eaf106f4e39b"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9441df1c3869ebae8dec5a4e8005f5e83658c94f3a57e4270d9d16848c0cc7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "731aea9ef8144eedb062f0c53e1596fbf948e0e418839d5576d3c15aad5306e9"
    sha256 cellar: :any_skip_relocation, monterey:       "1e480134eba73674c068f64df27333ed6883ecc2f54ba96c63791beb45c410c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d20188b7dccbf64e2e57a6f3d8b24ced300c1663e58fc8de3d28cb9ae251b479"
    sha256 cellar: :any_skip_relocation, catalina:       "b6a97a1431d6cb1bfb0bc607b8f26c0bf84bf531a182ba36a551ba45ba691d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eb47ff6159cf9969c8c838b7b4f24348b5e75aa4899a213e222d176e975891d"
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

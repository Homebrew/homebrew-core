class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.12.0.tar.gz"
  sha256 "1f972f070fa068a8a18b62016c9cbd00df994006e069647038694fc6cde45545"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a602a05d2f725975fee4437606cfde8930db9dc9ce897c5b123243fd25eb25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf554d10927910209503c4a673d378d8ba5be9c7d2f6e1f2761de08ab77a9985"
    sha256 cellar: :any_skip_relocation, monterey:       "b8efaf46aa705bde9b6174d613e7c388b00571e8180e0f3578383ceb59198278"
    sha256 cellar: :any_skip_relocation, big_sur:        "c580ee4ab092afe88ccf8b68c8654cb4a639d68432e72a6532c3a8bbcb5b92f6"
    sha256 cellar: :any_skip_relocation, catalina:       "cdbd9bf2d766b0d75df8bc8cfe6397eaf7ba91f3ccf4519703f0aad148ff99f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80adffee09ee9cf1121b7d286871c6751806a8ce2b81115e77a106c4e27d3866"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "xz"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end

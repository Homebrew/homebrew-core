class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.6.0.0.tar.gz"
  sha256 "3f5dd18b542caea267f7e520b672948e25a33e8675d70234b8372549feef0e47"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d2ac168fcd52a1a7be19fb16edcbf9e5f3252d05faed9a3e318b226963ef5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1999175de71ecaab0a30f28f2218eb1f28e062cc98f8847da0796a289ac2ace"
    sha256 cellar: :any_skip_relocation, monterey:       "12a1b933267ccef3398268c3203651fcbf8c1247926a94fd4695e4a60243d7cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f07b249b3c2d364d0f9002161f6f91c458b6c54ed8526dc7256fe5cffae2bad"
    sha256 cellar: :any_skip_relocation, catalina:       "800b378f7517d47a6fad5c7c32c737cb3ea71980a612d47ec3e9a0f486c2bd42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73fc6180b329fc1a63b38f7b499d5c3ad149b2f6b8b7f98653666db6ab567a41"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    EOS
    expected = <<~EOS
      foo =
          f1
              p1
              p2
              p3

      foo' =
          f2
              p1
              p2
              p3

      foo'' =
          f3
              p1
              p2
              p3
    EOS
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end

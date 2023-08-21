class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.13.1.0.tar.gz"
  sha256 "bb685094367e129319ce441c8d68748ee65263280267db8567b445466fb17e81"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7013b4e76d58e0e55be8fe7a09e86fc1a6596fa6ae0568c669bd7ca6c47b12be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3412b7d9bf9828ea2f45a717bf5b457b1707f714fb73861124567fb24ba367e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48c9b51eeaf7cb5b7ea7a8d9260b04b2aa0a333a87e5d2b275cefd8ad8f70b16"
    sha256 cellar: :any_skip_relocation, ventura:        "8e614c0f97ef93a991509c3d79465a2f3c55680c07a7fd1863cc5744d1acc61c"
    sha256 cellar: :any_skip_relocation, monterey:       "cecedf589f0f3f0e0298dc8f5ae30c69151de6550a6edc4435a70abefed16d1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c9d82551319737c8cb59330ae1bbce0e6303f42ccce28c75915d1ef9e9e7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f07c0fce4c6fdca4e74f1f6dfe5303d81aefa0f7b48bc506469c4d346d28b9"
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

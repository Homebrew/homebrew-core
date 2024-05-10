class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/refs/tags/v0.15.0.0.tar.gz"
  sha256 "0a04336ea6104cc6ba309ad0f66caed58181e47bf301dd55002a7e8729b87e5e"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc92cab2ea4a02b394fd40acc580044136730f1d58afcc4f841a461269f307c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c1dcfcfab82159ade01682563914c0f3e81bc5441da8e5564579252794029c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d2dea81c920b438019f0378f5cb9d40f506fc117db6ef7e4d76b645eea39fcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3da763a6e1106b46871183df0e59bf425e213930ef67af8c6666667a694fffd7"
    sha256 cellar: :any_skip_relocation, ventura:        "ce8e3545afe7cef350dc5506107b055453cedc912b42701fd276e5637eedbecc"
    sha256 cellar: :any_skip_relocation, monterey:       "352ec67930e7bb589c96edfb8115306186b49c919915166f148b4d05d1188767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b8d05924402e3f851b0fd6dc424a5698318a2133e8b3c90f55f98a9284bb3bc"
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

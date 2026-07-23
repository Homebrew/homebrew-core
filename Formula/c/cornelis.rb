class Cornelis < Formula
  desc "Neovim support for Agda"
  homepage "https://github.com/agda/cornelis"
  url "https://github.com/agda/cornelis/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "41787428319dbde15b51ce427451d4a48f14d54a7c42902d004458e232ca3022"
  license "BSD-3-Clause"
  head "https://github.com/agda/cornelis.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "823e1f7d48f7728b1938bfdc6f13d5d019eed5aea1dcaf0ffe76c0bf023b5c1d"
    sha256 cellar: :any, arm64_sequoia: "4c512b4a244010948e8610c46841d572bbbb27c6e9240a1b755a42cabafcfb51"
    sha256 cellar: :any, arm64_sonoma:  "c7646126bbcbc556b004d0a9d3ebd6339d6bdb5e2fdd05f290aa60dd24f1193e"
    sha256 cellar: :any, sonoma:        "dea66e9e498f4fc6ef595c67b62c522361bccff0e9432e438c021ac4768e39f2"
    sha256 cellar: :any, arm64_linux:   "8c6c596bab2944981e4a97e71ea42feedb60fbca35276e20cad140bfc3f6ffcd"
    sha256 cellar: :any, x86_64_linux:  "9ddb0a476cd96d13c732d6e41464ca3308279ff2918aeb2dc88d2be38135447d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    expected = "\x94\x00\x01\xC4\x15nvim_create_namespace\x91\xC4\bcornelis"
    actual = pipe_output("#{bin}/cornelis NAME", nil, 0)
    assert_equal expected, actual
  end
end

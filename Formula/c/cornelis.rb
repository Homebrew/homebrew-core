class Cornelis < Formula
  desc "Neovim support for Agda"
  homepage "https://github.com/agda/cornelis"
  url "https://github.com/agda/cornelis/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "b75d20ecf50b7a87108d9a9e343c863c2cf6fbf51323954827738ddc0081eff3"
  license "BSD-3-Clause"
  head "https://github.com/agda/cornelis.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5469975994b43e45788ff4b27058dc3284fa90f63be85001603abc5228dd76d3"
    sha256 cellar: :any,                 arm64_sonoma:  "845f96549a6d6c2937bedf9fb4031107f57b6b101275566702185b1625cfb733"
    sha256 cellar: :any,                 arm64_ventura: "410c0032ecb66fb98642251a207bfad302f466c1334f317f02d641a3e353f9c8"
    sha256 cellar: :any,                 sonoma:        "568be9e2acb19617e368400204f1664ed5b2839e6c96bf6adad497dd602b9511"
    sha256 cellar: :any,                 ventura:       "218969d2f9bd9584c280135fd53704646386bcac869f77ffad1586c458095547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5323616822e8de7e0390a4f8ad65399e27810da6f12587cffabae1896663b712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9f0f3d6779acf8d5586343012554985bf180d316cdf9e58874e0a0b02913ec3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", ".", *std_cabal_v2_args
  end

  test do
    expected = "\x94\x00\x01\xC4\x15nvim_create_namespace\x91\xC4\bcornelis"
    actual = pipe_output("#{bin}/cornelis NAME", nil, 0)
    assert_equal expected, actual
  end
end

class Prettyping < Formula
  desc "Wrapper to colorize and simplify ping's output"
  homepage "https://denilsonsa.github.io/prettyping/"
  url "https://github.com/denilsonsa/prettyping/archive/v1.0.0.tar.gz"
  sha256 "02a4144ff2ab7d3e2c7915041225270e96b04ee97777be905d1146e76084805d"

  bottle :unneeded

  # Fixes IPv6 handling on BSD/OSX:
  # https://github.com/denilsonsa/prettyping/issues/7
  # https://github.com/denilsonsa/prettyping/pull/11
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/848211f/prettyping/ipv6.patch"
    sha256 "263113acb0c2c99d0fefe979ac450cf00361cb0283df21564958cc4c38e98aad"
  end

  def install
    bin.install "prettyping"
  end

  test do
    system "#{bin}/prettyping", "-c", "3", "127.0.0.1"
  end
end

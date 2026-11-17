class FairyStockfish < Formula
  desc "Strong open source chess variant engine (with largeboards support)"
  homepage "https://fairy-stockfish.github.io/"
  url "https://github.com/fairy-stockfish/Fairy-Stockfish/archive/refs/tags/fairy_sf_14_0_1_xq.tar.gz"
  version "14.0.1"
  sha256 "53914fc89d89afca7cfcfd20660ccdda125f1751f59a68b1f3ed1d4eb6cfe805"
  license "GPL-3.0-or-later"
  head "https://github.com/fairy-stockfish/Fairy-Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^fairy_sf[._-]v?(\d+(?:[._-]\d+)*)(?:_xq)?$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag.match(regex)&.[](1)&.tr("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2ffeab4f25bf666156096a8f476c480aef341f4095bd1e1982268dc0bc5c796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f895429306b45cf7e3b48afc8e59acdf7a2e28ca8caf5cdf683cae285967109a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9630cdfb4334c4eb98c7487cd9834ce5abf60f4a1d267820d9369e3d974846a8"
    sha256 cellar: :any,                 arm64_linux:       "a7821a06bf2b02fa896d1d539c8fb2cae0bfd530fc75afee948273e179d8150b"
    sha256 cellar: :any,                 x86_64_linux:      "af04175e33f678d7261c7c8d4bff7ef7556e0983c5adcabb3cd1772b4100ca38"
  end

  deny_network_access!

  def install
    arch = if Hardware::CPU.arm?
      if OS.mac?
        "apple-silicon"
      else
        "armv8"
      end
    elsif build.bottle?
      "x86-64-ssse3"
    elsif Hardware::CPU.avx2?
      "x86-64-avx2"
    elsif Hardware::CPU.sse4?
      "x86-64-sse41-popcnt"
    elsif Hardware::CPU.ssse3?
      "x86-64-ssse3"
    else
      "x86-64"
    end

    args = %W[
      PREFIX=#{prefix}
      EXE=fairy-stockfish
      ARCH=#{arch}
      COMPCXX=#{ENV.cxx}
    ]

    system "make", "-C", "src", "profile-build", "largeboards=yes", *args
    system "make", "-C", "src", "install", *args
  end

  test do
    system bin/"fairy-stockfish", "go", "depth", "20"
  end
end

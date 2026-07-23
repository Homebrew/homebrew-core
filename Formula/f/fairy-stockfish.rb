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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44c93f2b4f6e3b7ff1daa96bce98e9bc64b34c343921b6e145a23bf153131b2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b70af3b59355821eaf2ee870e0f962159bf599b8964c1ba965cc848c0cd9708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3523a6ba3cf152a83e798aeb19298fc8b59df95194441f8dba655d56264867c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1943dab5d7ebe253c43cde8c33d5683a08619be682dedc41f6b4c107f0718c71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4ffe9bc9209dbe890aac368fe2c74f7d6793ea9ece4ff6f837148dfc3405f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8316c36ce185f713c34e19e6da7c5d5033b4d7ffd4d850d6fad6e65b5d187683"
  end

  def install
    arch = if Hardware::CPU.arm?
      if OS.mac?
        "apple-silicon"
      else
        "armv8"
      end
    elsif build.bottle?
      if OS.mac? && MacOS.version.requires_sse41?
        "x86-64-sse41-popcnt"
      else
        "x86-64-ssse3"
      end
    elsif Hardware::CPU.avx2?
      "x86-64-avx2"
    elsif Hardware::CPU.sse4_1?
      "x86-64-sse41-popcnt"
    elsif Hardware::CPU.ssse3?
      "x86-64-ssse3"
    else
      "x86-64"
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}", "largeboards=yes"
    bin.install "src/stockfish" => "fairy-stockfish"
  end

  test do
    system bin/"fairy-stockfish", "go", "depth", "20"
  end
end

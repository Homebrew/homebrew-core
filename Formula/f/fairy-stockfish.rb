class FairyStockfish < Formula
  desc "Strong open source chess variant engine"
  homepage "https://fairy-stockfish.github.io/"
  url "https://github.com/fairy-stockfish/Fairy-Stockfish/archive/refs/tags/fairy_sf_14.tar.gz"
  sha256 "db5e96cf47faf4bfd4a500f58ae86e46fee92c2f5544e78750fc01ad098cbad2"
  license "GPL-3.0-or-later"
  head "https://github.com/fairy-stockfish/Fairy-Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^fairy_sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee205839b2f569fc11c0b2d09502a866be0cda2195f04a73cbc9329f2642ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c6b1790bc144c874f7a1f737814c391380c47439b304c5c8e0ef368e773bc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbf99586202d3f28f7bfdf09830f620631030ae85276caf38d2b0d3246b22f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d1e77f421472a96ed0281cf542c4c8d6edd58c181ddce745fc1901659e68593"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba82fe79eb4b379870174e79a83b61136a519b94419a471bcb6b20754d015d86"
    sha256 cellar: :any_skip_relocation, ventura:       "c5ed0d702fac374bebd45b8a2a9e8074c887bda62e980f2528c5b35f94296650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a1cdcecf55712d376a05918b2ec1423f3ac0f56eae9b6c8fcfe3a8687f3312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aba797d91cba8f0b56caf85f3d55e4c2fdf4a83bb1be0c11255fa580c320ed53"
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

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish" => "fairy-stockfish"
  end

  test do
    system bin/"fairy-stockfish", "go", "depth", "20"
  end
end

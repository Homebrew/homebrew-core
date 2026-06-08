class Hexer < Formula
  desc "Hex editor for the terminal with vi-like interface"
  homepage "https://devel.ringlet.net/editors/hexer/"
  url "https://devel.ringlet.net/files/editors/hexer/hexer-1.0.7.tar.gz"
  sha256 "4e4ee48f7c9b0f62ecf5e5012d280bcd6f2bbd35e77facb769ac912278f4ed08"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?hexer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eef99329e5443ebc3f24cfdcd2c8c725ab015a620af9f1a4530f72afa3029e77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f91b873bcf76427fcdd9af9eec5508807e028b0cca27334600132f00e6d994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15cb867de476b9f6db212b94102d7963375719cd66f121fbf7f0144e8f361aa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41fca237e2b190ecf39c96d515ecad79eef914e6947b54a45c656e38f3ffadd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2914fe57154b3443708ca48d26df3ab1a2b1f506113c9669297e9b8d3cd26e6f"
    sha256 cellar: :any_skip_relocation, ventura:       "570c1a10b6e713d104c8ffac9f4d23962c4823064ab9530507c02ad9fa1bcb07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3329fa37a49780438ad6fe2f84bfd10606064834b98ecae0c444c163f8cf964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab11889d6fca09b6b36bb75fda742c4d6f584db0e8c6f28cc1ed24ba1f8c949"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match "00000000:  62 72 65 77", pipe_output("#{bin}/hexer test", "i62726577\e:wq\n")
    assert_equal "brew", (testpath/"test").read
  end
end

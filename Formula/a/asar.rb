class Asar < Formula
  desc "SNES assembler for applying patches to ROM images or building ROMs"
  homepage "https://github.com/RPGHacker/asar"
  url "https://github.com/RPGHacker/asar/archive/refs/tags/v1.91.tar.gz"
  sha256 "9192664c888d6ed13a96b15ad81cb98e9e0334531bdfaf8f77abd071816a0770"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9fc72b7ad80208c498d9c39deb40ed59ec0d998363123cc9c6322756d99db7d"
    sha256 cellar: :any, arm64_sequoia: "dd07f32a111c15b3ced7e634f4a0b33635fa502f6272428ddda03f829a7b5f07"
    sha256 cellar: :any, arm64_sonoma:  "20a6d6ac751447da0e617116f9f67a7e24a34ec62e3c5b490ddf1c660577198e"
    sha256 cellar: :any, sonoma:        "5c59a24a6f350057fc37b962d80a055d943c752ac96914a334921da82da1b17f"
    sha256 cellar: :any, arm64_linux:   "1c441c673941b08e274e7dc1e5c0d644e580d0e724a55ec3faa42c0838b9d4f1"
    sha256 cellar: :any, x86_64_linux:  "17570103fe26f36e0b49df22899599e8e1d85e14094c4f40e5d550c4bbde5c5e"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build

  on_sonoma :or_older do
    depends_on "coreutils" => :test # for sha256sum
  end

  def install
    system "cmake", "src", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.asm").write <<~ASM
      org $008000
      db $78,$9C,$00,$42,$9C,$0C,$42

      db "HOMEBREW TEST        "
      db $20

      org $00FFD7
      db $0A

      org $0FFFFF
      db $00
    ASM
    system bin/"asar", "test.asm"
    assert_match "9f044afb5cb6b41dac792d77cb2a7d29a5abf03c80797a96809b08bdfd46685b  test.sfc",
                 shell_output("sha256sum test.sfc")
  end
end

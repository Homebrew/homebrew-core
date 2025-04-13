class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf/"
  url "https://ftp.gnu.org/gnu/gperf/gperf-3.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gperf/gperf-3.2.tar.gz"
  sha256 "e0ddadebb396906a3e3e4cac2f697c8d6ab92dffa5d365a5bc23c7d41d30ef62"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3999d6d91b975ef19c1f9bf1f101229b268f2c6a7a4717a2d6b4905606d4eb57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0c71eff24070e17a749c62e01618027be506f1feca179bc1175a15b02c4e353"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cd0be041b86cbef7af1b080a0661ae6c210d469024874fc8b915a37aa108283"
    sha256 cellar: :any_skip_relocation, sonoma:        "4425822d3b225d90f5f1f91108408e9411a5a39b1ab8ec9ccec18b7a0998e545"
    sha256 cellar: :any_skip_relocation, ventura:       "8ba47621e3a740003818c597ca971ead05793a5fd6ff58ff33eff04e811327ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c839cdaaf46f73a5fd51ed4f81e55c3615c92242f66ff7a403054cef4b6d4400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc882ee19e27d0c9807443a7f28f0061874399a94b185b16d752f385f0b2723"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output(bin/"gperf", "homebrew\nfoobar\ntest\n")
  end
end

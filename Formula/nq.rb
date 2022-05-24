class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/leahneukirchen/nq"
  url "https://github.com/leahneukirchen/nq/archive/v0.5.tar.gz"
  sha256 "3f01aaf0b8eee4f5080ed1cd71887cb6485d366257d4cf5470878da2b734b030"
  license "CC0-1.0"
  head "https://github.com/leahneukirchen/nq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b050bc2a3667662b9f12ec156c2aa73758b5a58803029c56172ba8c8ce0dd0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f30174530722649e4515ff41c06d3d4d88d96db7a5f69299ee827c2112c9274"
    sha256 cellar: :any_skip_relocation, monterey:       "3b0266ca4e323c0d7edabfe047d20d2dad6065d2d41708e89ed29af617ddc5c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "57fa203a54904a2fdc06cb0031a6d2bea0cfcd3137562b0c64cf3ac92dc4dd7f"
    sha256 cellar: :any_skip_relocation, catalina:       "c33190abc0b66757582008bf593ab4e37c977f7d9faeafdea6b1631c455ca4a6"
  end

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match "exited with status 0", shell_output("#{bin}/fq -a")
    assert_predicate testpath/"TEST", :exist?
  end
end

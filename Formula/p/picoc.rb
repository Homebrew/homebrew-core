class Picoc < Formula
  desc "C interpreter for scripting"
  homepage "https://gitlab.com/zsaleeba/picoc"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.com/zsaleeba/picoc.git", branch: "master"

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/picoc/picoc-2.1.tar.bz2"
    sha256 "bfed355fab810b337ccfa9e3215679d0b9886c00d9cb5e691f7e7363fd388b7e"

    # Remove for > 2.1
    # Fix abort trap due to stack overflow
    # Upstream commit from 14 Oct 2013 "Fixed a problem with PlatformGetLine()"
    patch do
      url "https://gitlab.com/zsaleeba/picoc/commit/ed54c519169b88b7b40d1ebb11599d89a4228a71.diff"
      sha256 "45b49c860c0fac1ce2f7687a2662a86d2fcfb6947cf8ad6cf21e2a3d696d7d72"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "190a69c827d572ea5c16c28021907f6eb657eaa4b3381fc379ebeeda16e1c102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "43e537db7d3f77463969b213bbb8fcaed5bef26c4c1600989140bc4c8ce77f80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10344b6c0e17692656a97e7ef1149cc7ab5797df714986bd420a211f6cd4cde3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37c038b18d6e2dd02636901429fabaced73eb533eb1254e06bb3a74f53906a66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a572c33c2dc1b913132786154a5013d4c380bd1dcc5d64a696071ccb15b2589"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b39c116bb09cdd9f91143aaf9c928feadac8b281807e06ab87c4ca2992c13ec4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e15bc0d7c0729f0a32ef47dedf7b50a84cb2a9a5ab6238885cdf26b50e8f779"
    sha256 cellar: :any_skip_relocation, ventura:        "9237788f85a665a1e368d6cae408450ea66ae3ad8c0fedcf3fc659ceab88f73c"
    sha256 cellar: :any_skip_relocation, monterey:       "f5483717ef3070c38ddd65011f312f8da456f74aa9c7f6b13480d4e40aa52782"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d9836d62b70b7fe1117f4697417d9a03615639f2ff1390f0f1d21003426bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "168aebca830b719b3645b682c9c3f1208663b6853b62d68ddeb2957ee6c8bc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1054643132b3c1196e1630e283c7295c73e57d7e616f08eedba7ea03c5820cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc930c96079c197b124afefbcf14153ad4435e9ff95d42753348778f6efb85e"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags} -DUNIX_HOST"
    bin.install "picoc"
  end

  test do
    (testpath/"brew.c").write <<~C
      #include <stdio.h>
      int main(void) {
        printf("Homebrew\n");
        return 0;
      }
    C
    assert_match "Homebrew", shell_output("#{bin}/picoc brew.c")
  end
end

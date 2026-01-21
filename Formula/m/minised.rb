class Minised < Formula
  desc "Smaller, cheaper, faster SED implementation"
  homepage "https://exactcode.com/opensource/minised/"
  url "https://dl.exactcode.de/oss/minised/minised-1.16.tar.gz"
  sha256 "46e072d5d45c9fd3d5b268523501bbea0ad016232b2d3f366a7aad0b1e7b3f71"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?minised[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5793a31a1201a62923112332d5197945ba6dc946d207b333f5f32ed0eeb2d045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "97b244949148f54cfd90253c3d903a6b07efdc7b3cbf3da2606bfef854354977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e30694f00f2837a20d9ea1763374d37480372134ad47743cf31eb4179a2bde8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81091d0acb8b307dfbf7e699f3a6bb3ed377b3300d931f79e39ef69b54db17e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "794c547b94bc09df42a03d11daa4561439a2f7b3266e354c94b3972245d2192d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83e070332d7ffada88d210ebb159b0d73a2020d3df02fdf72453c0bb3e78dd21"
    sha256 cellar: :any_skip_relocation, sonoma:         "8944c486d6e2de3aba6033f7e2748cb86c659f0209ebb5a2d80d846ecac48bcf"
    sha256 cellar: :any_skip_relocation, ventura:        "b9e479e8520bb78c3b47ef9e04d95e42e26e1ac7f79b2e2673ba56842b5fed9f"
    sha256 cellar: :any_skip_relocation, monterey:       "7e2091cafe98c90c2a10b7b009b8928845fff475f5fc085be54160b029fd3cb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c303cd44d317dbdb8e32fb3ace5200d60f707176fc11bf32b57015bd1ac99a57"
    sha256 cellar: :any_skip_relocation, catalina:       "0e5a711b146eceb3feea676e6816998eb82442f1632831bb95b97fa09566bf75"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ab2195d826ed450db77cd8e44601dc47bbb4027d0e9777b7ab075b6b9d1513c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c46de1901db191b4cff269feb8d236fdc53ae72a83609699e4ed1a2afc6f789"
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    output = pipe_output("#{bin}/minised 's:o::'", "hello world", 0)
    assert_equal "hell world", output.chomp
  end
end

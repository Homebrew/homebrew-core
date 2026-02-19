class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat396_src.tar.gz"
  version "3.9.6"
  sha256 "f8cdf28b21517b2d6016f87578f79efda7e6720cf97834f35e5abe679f482dd6"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "550356bc9c8e1d8c3fa37ad296ea7f99c9596f1c914ad9d7a4deb30353c46348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f18f9b18124e58e1e2cc416547e44b0ce7defe61931a3dd616fde1541759a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ddfaab77d367770a8881bcba62f871bc68320bc8a2ffe29c20d747377dbe6bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b35c9164f8071bf35c9a99f240ae9a550a49e8525b8ede05a00a820a9329850b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99247d331940b7e54622ce3ef777d7160480291be4f523c8f704100482e2b58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b9ca0f0c1df65f5c28a70dec5cf612544c4c448e8d565d46f4a1ea0912395b"
  end

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end

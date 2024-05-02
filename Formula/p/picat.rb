class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat364_src.tar.gz"
  version "3.6.4"
  sha256 "d6810e4580e10cd134eb5fc742952563fa2b37ae662d4276394a597e8a66eef9"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca34bd4546f5cfc094e7efc9932be4168ddf010fd4d5333d599ee797b8be8612"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524093880288fc773664e0cf1d073ea0b59d95302131071ab20c0dec97ebb222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6af0d52c19d2df10c9b3490e86c752961b3dc3a7ab12dd12f87f33b6509813dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "82969017300c1dd3bdb531a30bc07c1e3e714b14307fe37b318b70e3c7bfd10a"
    sha256 cellar: :any_skip_relocation, ventura:        "75b667b3763838c5df66fa789dbe46596c9b35f6381ca3f4c9a8921e69ae37bc"
    sha256 cellar: :any_skip_relocation, monterey:       "fab82ea379b9456b70cbe98956f13d5ac1ef7f3c95b271b379531066503bf6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d68ba71f04b6ce1ebf11b5efc8dba549244948698d8ea9b3ab7946595abc62"
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

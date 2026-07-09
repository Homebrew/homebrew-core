class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat39_10_src.tar.gz"
  version "3.9.10"
  sha256 "7e05e363482a54be5d2ef9505a9f2f9f9bbd9f82af9279961415173179c71779"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2891bbcf81ed34a86cc032f779c1cdc707db09b4cf3c4ef9b128d174f81d15da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "602c92d0a80e2a33c16b7ffdc5f7744ebd0126c7202d7845824ae0114833db45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b33b604cf75706fb391c75f9403f7c5775fdde9201e7f72b10659b82a06f14"
    sha256 cellar: :any_skip_relocation, sonoma:        "46477a815e33448ced8066780471815de4218c25accbfbb67b2c409e43e18ed6"
    sha256 cellar: :any,                 arm64_linux:   "964d16aabf8afcbe74845a0e34b9b7bb62a082f48e7528ca84556d3b35315dd9"
    sha256 cellar: :any,                 x86_64_linux:  "fbb00762bb5c15f464295707c6838e30568096fdc78939da735d8a0bf9af0f46"
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

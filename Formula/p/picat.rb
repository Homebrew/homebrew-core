class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat395_src.tar.gz"
  version "3.9.5"
  sha256 "b993f2949e14a1724bb3b05bd856f5fe79d1d167ee79b7e92eeb4ce050572051"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7733afa877ae6738e9a4e0f1d92f5547818d8127b727b3bdb7b7e564672c3686"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bcbbd30e29759aafe5c3a168e2060530bef22fb791d9d15c80409b6fd875be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "069a89210239bcc92c36279de62a774e896434e70cb37ec16af4811130d9b0e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b849c0cbd07c742886be31f0abdef47139e6d21afd20dfba6c82fb1645dbf7ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604cd6575b984d2e2883871f4feb4578789e19f307e007576865b7903c30fe22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184b89bbe6c7971e3898e5ff039bb0614081a1a4c8960a49562c3ba7b681aa5d"
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

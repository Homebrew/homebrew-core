class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat397_src.tar.gz"
  version "3.9.7"
  sha256 "517d9c91ad2aa5f4d8052e4daa0bf21fe967278ec054d7eeb0f4f92db9edd250"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12c045c60f67d8c496dbea451667671e6af2c85775d493f545a973bf0eaa799c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3693880d35c890ea3d56ed63c4c3808f986f2cfe8c29f277575f26799014112d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa37076212474d679d885e9a3a7c943990ce4bbdb8a137727b26653ae63fb8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f866b2692d7f6cbd7fbe050aabf56520d8fec0bbc546457d7820ee4e69f0c5fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "730c61aeb6af897f47b0aa87e3d9811286409e25bce61f6b157164f25e4aa41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef530130c8609c7e58c0b236b224f0e17ae7062948f3ff0e65a55b8045cb0cb"
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

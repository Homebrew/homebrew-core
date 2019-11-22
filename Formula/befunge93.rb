class Befunge93 < Formula
  desc "Esoteric programming language"
  homepage "https://catseye.tc/node/Befunge-93.html"
  url "https://catseye.tc/distfiles/befunge-93-2.25.zip"
  version "2.25"
  sha256 "93a11fbc98d559f2bf9d862b9ffd2932cbe7193236036169812eb8e72fd69b19"
  head "https://github.com/catseye/Befunge-93.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61b8cd95c36c1bc4729663a3023416a3fecea6a0d47d21e8ef37edf032b8a6b4" => :catalina
    sha256 "f77d79e0bc06317441221cf22696f3be81f75221531f63bcb71d819954e2884b" => :mojave
    sha256 "3e82d14825ded095e92ebec797f682a65c7ada55ec178e069d0093eb29da8e4a" => :high_sierra
    sha256 "302f0c69592719782676dc2873a9a9faef3f72b6ec7bb225d60e74ca1cc0f640" => :sierra
  end

  def install
    system "make"
    bin.install Dir["bin/bef*"]
  end

  test do
    (testpath/"test.bf").write '"dlroW olleH" ,,,,,,,,,,, @'
    assert_match /Hello World/, shell_output("#{bin}/bef test.bf")
  end
end

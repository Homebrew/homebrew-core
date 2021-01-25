class Befunge93 < Formula
  desc "Esoteric programming language"
  homepage "https://catseye.tc/article/Languages.md#befunge-93"
  url "https://catseye.tc/distfiles/befunge-93-2.25.zip"
  version "2.25"
  sha256 "93a11fbc98d559f2bf9d862b9ffd2932cbe7193236036169812eb8e72fd69b19"
  license "BSD-3-Clause"
  head "https://github.com/catseye/Befunge-93.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bba6c29ce6655061c2f0323b1ee778c275e0bc18f850158274a03af1ea666fc6" => :big_sur
    sha256 "05324749e9d37d4bdf4b6737ddcc2f48489755c60a38752f4cf8dc51e1b93085" => :arm64_big_sur
    sha256 "190fa82b0fef31f096a102f3b33205112cb206f578813f7ac78f78617c7d73d3" => :catalina
    sha256 "23dd470caf59b04ffb652e46061760701269a8a79ce93c3afd71318da000112d" => :mojave
    sha256 "c8a1e2085413dd0da3036462eeffed2f01198da92f128f4951c0885bf69a0149" => :high_sierra
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

class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.5.0.tar.gz"
  sha256 "66e00a4095121255a9740a16a8a59daa289f878f2e1e77ba6a9f98d6a671a33c"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6b094c9b081df58a849cc2a982022937c421ce90059e9fedf52e332f85ce138" => :sierra
    sha256 "6004ebee365589110a6579a142a90b653ab876d167056614d97c249331fe4ab2" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/natalie"
    share.install "NatalieExample"
  end

  test do
    generated_code = Utils.popen_read("#{bin}/natalie #{share}/NatalieExample")
    assert generated_code.lines.count > 1, "Natalie failed to generate code!"
  end
end

class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.5.0.tar.gz"
  sha256 "66e00a4095121255a9740a16a8a59daa289f878f2e1e77ba6a9f98d6a671a33c"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a43680f8d24e3523ee7bc680dd570fddaeb4a208d9664f43219b35b918b0cb17" => :el_capitan
    sha256 "49c77d43fca5c3e76dfc00d5d8c4465cb2e98772415a3372b747b9f73b3eeff6" => :yosemite
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

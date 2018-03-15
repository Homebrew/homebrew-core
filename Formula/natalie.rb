class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.6.5.tar.gz"
  sha256 "ea0586e07ad4aaeea557fdd6bc8a874b206259568c4d9a74932dac7bce00acc6"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2b7df54c0844ed33993ba110556bb3547423fd8d22b5034af29f65ba7eade15" => :high_sierra
    sha256 "6e101ed8ac70707b8366665bea49d98c9095d9a8f91b3736a772d968c4045ed8" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/natalie"
    share.install "NatalieExample"
  end

  test do
    generated_code = Utils.popen_read("#{bin}/natalie #{share}/NatalieExample")
    assert generated_code.lines.count > 1, "Natalie failed to generate code!"
  end
end

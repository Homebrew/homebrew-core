class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.6.5.tar.gz"
  sha256 "ea0586e07ad4aaeea557fdd6bc8a874b206259568c4d9a74932dac7bce00acc6"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a74604b0bca4ca91805483617f07f6a326be85ac55dcb29e4934acfa4298d4e3" => :high_sierra
    sha256 "eabc1b23bc1e9fc87eb5d37eeaa83731a6f0574b0c4506c6202af7550e8bacc5" => :sierra
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

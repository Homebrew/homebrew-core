class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.7.0.tar.gz"
  sha256 "f7959915595495ce922b2b6987368118fa28ba7d13ac3961fd513ec8dfdb21c8"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5010d3c20e1ff431b881e997ede4673564f79016e7271888b462f8a39d40900f" => :mojave
    sha256 "5b574a8d5a8c2e386b1eedeee8b20e77db84138898be95dcc4b0ab2fcb81fc88" => :high_sierra
  end

  depends_on :xcode => ["9.4", :build]

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

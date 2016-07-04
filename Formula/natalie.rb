class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.4.1.tar.gz"
  sha256 "c2ef0ad5f68294ac8886abb1a8c20a6f647d81f2a7e5452c73b572382229b38a"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7fd9b48527854344686e872a961ace175033d554ed37819e5fbae83cacd046e" => :el_capitan
    sha256 "ca9641d7eba42ec3f565b32ec4277ab98666b715f3a7ea9f4dd1b0689188160e" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    mv "natalie.swift", "natalie-script.swift"
    system "xcrun", "-sdk", "macosx", "swiftc", "-O", "natalie-script.swift", "-o", "natalie.swift"
    bin.install "natalie.swift"
    share.install "NatalieExample"
  end

  test do
    example_path = "#{share}/NatalieExample"
    output_path = testpath/"Storyboards.swift"
    generated_code = `#{bin}/natalie.swift #{example_path}`
    output_path.write(generated_code)
    line_count = `wc -l #{output_path}`
    assert line_count.to_i > 1
  end
end

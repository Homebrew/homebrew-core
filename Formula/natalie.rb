class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.7.0.tar.gz"
  sha256 "f7959915595495ce922b2b6987368118fa28ba7d13ac3961fd513ec8dfdb21c8"
  license "MIT"
  revision 1
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df7c39d8bcb8d60b095d9b9b90207042791d994f22a53c97e709aa16768a9b28" => :arm64_big_sur
    sha256 "218ec8bb0ac3ac4de7a6fa8489f3ad7013b1beb051a7c0e74a6e37ade79eee6c" => :catalina
    sha256 "9dcc093fc648175eb165aec20413246ace7427d0d3c4a9884d37cfad9a851dca" => :mojave
    sha256 "dd51e00a1969ffdd478e954bed48bedd1c5a9813b67931aa146711f49cb58223" => :high_sierra
  end

  deprecate! date: "2020-11-21", because: :repo_archived

  depends_on xcode: ["9.4", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/natalie"
    share.install "NatalieExample"
  end

  test do
    generated_code = shell_output("#{bin}/natalie #{share}/NatalieExample")
    assert generated_code.lines.count > 1, "Natalie failed to generate code!"
  end
end

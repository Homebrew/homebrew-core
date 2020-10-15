class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.8.2.tar.gz"
  sha256 "5647d78166a2d768b98ae03bd40427f2263b28b81213882d42f638c5b96619e2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "38cb293ea71d8d11e422838e378cb67b09334590ed501e45b9a0f6da7d70f3ac" => :catalina
    sha256 "cef323546a1e6978ca5a67f9f18333819e318bbe136d9ba210c1fbd89f4af82f" => :mojave
    sha256 "d63ae62eff912723629b9d991fb77771f700ee306cf3b3cc40a934e3f2f13dd1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end

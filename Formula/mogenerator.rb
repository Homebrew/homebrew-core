class Mogenerator < Formula
  desc "Generate Objective-C & Swift classes from your Core Data model"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/1.32.tar.gz"
  sha256 "4fa660a19934d94d7ef35626d68ada9912d925416395a6bf4497bd7df35d7a8b"
  head "https://github.com/rentzsch/mogenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee338f12698ed624689a19d0d65bf7a7b471b1e70319757923c1f8e7feb3e597" => :catalina
    sha256 "634c78c86eef97f5d9feb531b3864469806b672e0ca5dff6cd00762b76f3084c" => :mojave
    sha256 "5e477fee1c770d7b4b676c1627017727a925aafd81fd38c30037691a4b624ebf" => :high_sierra
    sha256 "aadafc4a282f98739d296f105f24c94666c90417f92c05644fd965dbb42aa37d" => :sierra
  end

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end

  test do
    system "#{bin}/mogenerator", "--version"
  end
end

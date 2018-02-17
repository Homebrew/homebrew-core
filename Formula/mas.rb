class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas/archive/v1.4.0.tar.gz"
  sha256 "9fe07103c285ea69db1cdf527c6c8def5732c028d7014313a04bb0cf5b6c2302"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7eefc5d4705fbe682c9d5a11b9719de0d6b1efe7998201f4d9367d1367cc79e" => :high_sierra
    sha256 "ea490074922007a1da7b42f51c4c13c4a846f2e0a810feb30df65ca57c6726e7" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    xcodebuild "-project", "mas-cli.xcodeproj",
               "-scheme", "mas-cli",
               "-configuration", "Release",
               "SYMROOT=build"
    bin.install "build/mas"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
  end
end

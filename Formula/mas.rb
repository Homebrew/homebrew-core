class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/argon/mas"
  url "https://github.com/argon/mas/archive/v1.3.1.tar.gz"
  sha256 "9326058c9e572dd38df644313307805757d7ea6dfea8626e0f41c373ecbd46b5"
  head "https://github.com/argon/mas.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dabea41de5ca826bba584a0d00f8d7b65024f504e5f5fa9dd7639c2f9e410421" => :sierra
    sha256 "894480201eb8bd8772378c844860fac3d9ff2fdb75fe5f0001581b14c8cbceed" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

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

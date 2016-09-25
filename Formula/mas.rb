class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/argon/mas"
  url "https://github.com/argon/mas/archive/v1.3.1.tar.gz"
  sha256 "9326058c9e572dd38df644313307805757d7ea6dfea8626e0f41c373ecbd46b5"
  head "https://github.com/argon/mas.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05c79cb39d5ae962a0a0f547ad36d88d62d355a69936e8bd88a9ce5b6a1daf77" => :sierra
    sha256 "360664b0d88c79c1e917df02bdb749bc1cdc9337075059944c49bb8f451baf71" => :el_capitan
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

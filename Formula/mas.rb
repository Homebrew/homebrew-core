class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/argon/mas"
  url "https://github.com/argon/mas/archive/v1.2.1.tar.gz"
  sha256 "ebf594b2b4ef348e2aea770960215feaf569d6cf5b3c5f104402c5c0eb9f46e7"
  head "https://github.com/argon/mas.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf2b90e3f95ecc72899656d72b445a149c375695aca7a8416e5d86f25cf08109" => :el_capitan
  end

  depends_on :xcode => ["7.3", :build]

  def install
    # TODO: remove when >1.2.1 is released
    # Reported upstream: https://github.com/argon/mas/commit/3a02d7
    inreplace "mas-cli/mas-cli-Info.plist", "1.2.0", version

    ENV["GEM_HOME"] = buildpath/".gem"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", "#{ENV["GEM_HOME"]}/bin"
    system "script/bootstrap"
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

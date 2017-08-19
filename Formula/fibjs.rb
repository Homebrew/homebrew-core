class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.11.0/fullsrc.zip"
  sha256 "aef7f21f5cf2e25b653b28a8ada245f9e7b43e0f9da5c71ea9bf4da599fb726b"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0245da7cf696a2ba9ec1865123b18e9ad0ff859bdb8657c9f6e2ad180dc9869d" => :sierra
    sha256 "4ff4a71ca03a984803622635d7ae2714a52bd6f17dbd57ee8aa96730df2602b7" => :el_capitan
    sha256 "c72a554505d8982cc22237ed77a98144edc9c3e207a68d9f3df04af1cb03e45f" => :yosemite
  end

  depends_on :macos => :sierra # fibjs requires >= Xcode 8.3 (or equivalent CLT)
  depends_on "cmake" => :build

  def install
    # the build script breaks when CI is set by Homebrew
    begin
      env_ci = ENV.delete "CI"
      system "./build", "release", "-j#{ENV.make_jobs}"
    ensure
      ENV["CI"] = env_ci
    end

    bin.install "bin/Darwin_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end

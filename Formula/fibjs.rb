class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.21.0/fullsrc.zip"
  sha256 "75d97101dd892ffd0d27b28e9d380bedaf25887eac0a7ed2e59e06afe2a0e78b"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a21c86701e93431dbaef65a542c45fb1b80f893c34b5da07735e9906b032923d" => :high_sierra
    sha256 "eb23cb1b200acfd1614131a0a57f71359c5f3ef93e4fcc13875af437b0624bbc" => :sierra
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

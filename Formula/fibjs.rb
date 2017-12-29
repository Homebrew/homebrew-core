class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.21.0/fullsrc.zip"
  sha256 "75d97101dd892ffd0d27b28e9d380bedaf25887eac0a7ed2e59e06afe2a0e78b"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "173c67a62b69cf90d98f406afc735a3b6c4c4de56e843745790200364d4dbf9e" => :high_sierra
    sha256 "3df4de11d8b4daa5678ef66237a0ccbf369f3da0d1fa23c47809c06acf058fa5" => :sierra
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

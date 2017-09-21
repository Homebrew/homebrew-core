class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.14.0/fullsrc.zip"
  sha256 "2b748cb9c7a670d3381f72cdd7dc3de8cd32463963720d13d099811f9b5db2f3"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43cf28075437aedecfd17e3c3a9dc7e34a6bb098692d4a788970d3ca4a4835b9" => :high_sierra
    sha256 "eeac2ef8b9e03a21ce1c048a33d8479ce950e047760aa2f7034b59e11c301f31" => :sierra
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

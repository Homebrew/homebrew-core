class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.14.0/fullsrc.zip"
  sha256 "2b748cb9c7a670d3381f72cdd7dc3de8cd32463963720d13d099811f9b5db2f3"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8aa1dda819e2bbf2ec0184cee8bca3ca7fec31e72b3918ed3f022ffe30265d80" => :sierra
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

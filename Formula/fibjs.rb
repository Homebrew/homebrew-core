class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.11.0/fullsrc.zip"
  sha256 "aef7f21f5cf2e25b653b28a8ada245f9e7b43e0f9da5c71ea9bf4da599fb726b"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45e761b69aef1a69eed0ab274973cb4742b7a3fd98d592a896d6204dbe53a8f3" => :sierra
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

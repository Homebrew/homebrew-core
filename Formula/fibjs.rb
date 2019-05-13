class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.27.0/fullsrc.zip"
  sha256 "2cdfce3007d2ce337b5f98b2c3f7590f7155932c8f12c4711bb3b50a36e70744"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "184dbe978e4283f82ec7a9c8760beb7de36beea4e1ec318bd4441f0df3b20619" => :mojave
    sha256 "b0644c726c59d6e378117861dd7df2f461160eea7c10a14b551ce6999667eef3" => :high_sierra
    sha256 "c92cd08f2df73f58392e8cb756c37cd0a7cc428658a4a38dce831e8357682987" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :sierra # fibjs requires >= Xcode 8.3 (or equivalent CLT)

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

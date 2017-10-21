class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.16.0/fullsrc.zip"
  sha256 "57bc3aa95eb85fcc0ee4809f4ba8d90691db65f53ffe5cbb17a48cfcb98adff4"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88967b7728773c497176bdb64d9bdf327b61dfa98ed8b7b0b5a26f7065fb7928" => :high_sierra
    sha256 "010fd3d381f3b1196169dc05d482c3f92ce371b7c4882b45fd8a1700bb922e57" => :sierra
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

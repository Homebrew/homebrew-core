class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.7.0/fullsrc.zip"
  sha256 "1cc6050481898f3c7f1e8ccf62a72ffe0ea9dd767072d2dc5078889ff9a55cb8"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7ff2a93acbed8848dcfb0ef889bc5d561b47f2f0b9e835df9852dc26a5d0622" => :sierra
    sha256 "0988b61f9eaa85b250e175ca02190f8a75fc8049fb3ade479a7aee1efcacfad8" => :el_capitan
    sha256 "9d828b9932a830c7a9153dde3a01dd77578506bee695cedffe3417ed3e1004d7" => :yosemite
  end

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

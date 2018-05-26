class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.24.0/fullsrc.zip"
  sha256 "539ba5b208d8f1a2748e5012c758475f55d859af0a8f9d0d4415f7413d4ed3d1"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80628451ce3f7d10b52fedca68488f9f9d79aa87d41c96a16af1d2d98972121c" => :high_sierra
    sha256 "575b15fdaa9e83a5cfd3b5359e70aece2d5b6b716275ee3f3889ea82e4abe592" => :sierra
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

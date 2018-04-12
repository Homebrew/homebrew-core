class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.23.0/fullsrc.zip"
  sha256 "b2525373ce6eaa1edacdd3f43a2f2121311a51ce50f9c9539c195eaa513b52c8"

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

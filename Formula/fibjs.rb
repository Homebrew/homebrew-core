class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.28.0/fullsrc.zip"
  sha256 "f970927bc84e945617c4437a8689168cf6626b9b899b55ae239fbd80aa274945"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b25fe28bc5876bf1ce7387db9cff020c696a57179ec650f76242ec0f15793fb" => :mojave
    sha256 "9641ea8dbc01792070b39a2250821f85dcf4200418e985cca1a6b309cd240752" => :high_sierra
    sha256 "96c1dded1c8b1b9160b8f477ecc9cca3cdd448f0826506c884f325a6c580d9a8" => :sierra
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

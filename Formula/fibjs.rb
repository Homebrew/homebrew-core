class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.28.0/fullsrc.zip"
  sha256 "f970927bc84e945617c4437a8689168cf6626b9b899b55ae239fbd80aa274945"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88607ac1b27e38088880ab703f2abd76a88b38ddcae2da62ff6108e6bf9f3305" => :mojave
    sha256 "a332e5c7b8e75b627ff346bcca19d5fb167ffb05ba5ab8e62bc4234b54276aef" => :high_sierra
    sha256 "c66dc2e015e907055d655dcaa2843a5d638e97afd3f5ac7dcff87d830b233e92" => :sierra
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

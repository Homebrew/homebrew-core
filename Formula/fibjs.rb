class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs.git",
      :tag => "v0.5.0",
      :revision => "92a0d14ee241fffd29603963cafb1c1bc9a0dcf8"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de6fccf10add67ab5032cbd4076faed7a57cf6bd4554d6368e5e9445b463cccc" => :sierra
    sha256 "4fba6253c57036cd05f164145bc4a88ddc02e1520c5e2759a6c21540cdd65270" => :el_capitan
    sha256 "19dbceb26259056a2a458e63ff214cd47d456e527430c2c9a4c4090e82507d1d" => :yosemite
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

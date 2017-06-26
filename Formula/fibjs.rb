class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs.git",
      :tag => "v0.6.0",
      :revision => "84357506849297522e8c636d7ba295aaaeda4679"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9d37f8521d34fd380e16b7433ca66766480e599eb808ade16525a583378d7ca" => :sierra
    sha256 "3875928e31136851ca7280a90f9b411142aad775383481dee707319fb99b4557" => :el_capitan
    sha256 "26efb32806ce491bb75dcd7cec1d04594e9b7c9f63b71a1001e02c2929ea334d" => :yosemite
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

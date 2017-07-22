class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.9.0/fullsrc.zip"
  sha256 "3a8237db209c5eb47c77798252a4d783dc84e5f4a420887cfe7243450e404b51"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c04b1769994569e27e804dfefb8490336fbe19a2188696003880da7e81fd1348" => :sierra
    sha256 "0aa1a4f1abf37494f27d09b60c7ed061564546697566154128f19f6b5617c8ee" => :el_capitan
    sha256 "299b8fa624918d6c567094bcbc43eb1d92c4fab3f8ae4728d57d306bf883380b" => :yosemite
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

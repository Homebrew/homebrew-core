class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/en/index.html"
  url "https://github.com/fibjs/fibjs.git",
      :tag => "v0.4.1",
      :revision => "a267b736e20443f9ae8d808bbd8b7112a22d8d6e"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81ee585e8cba5f182ee68cb9be6a50acafd823f6c38ae6e16095a78105c266ad" => :sierra
    sha256 "a99b536c6544f2b22be73c030d55bb4cccdf02861d37ba3beaf1f63c6165968f" => :el_capitan
    sha256 "706f39e92ab350f6c41e057d2204349d5e7e81a5c617004b6ab175194c5bcc54" => :yosemite
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

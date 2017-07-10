class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.8.0/fullsrc.zip"
  sha256 "fa7627fd5e1fa812b501bda55f2a32b6e14694afaf6bb5fff8948151cbd51de3"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "671e60a59a7271362933388ca15473b8decb52002eafa1708e97daf074523038" => :sierra
    sha256 "5bfe16f820011bdc9155ae2c487f56e0368a9ffded6743962f96dc1114294c59" => :el_capitan
    sha256 "e0ab6578184ec213f395360d80138af658cd4e4f3a123b624f55e408404278a0" => :yosemite
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

class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.33.0/fullsrc.zip"
  sha256 "4a681b057598f1ebcdc7b943aba506bd942d7919b7c7fcb459a2c6d4ffdaab4f"
  license "GPL-3.0-only"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "805081981e806be46cc919002806f1518c2c2cb2421fbe97bc2ca5a00e4fb621"
    sha256 cellar: :any_skip_relocation, catalina: "93826d72189ebf83939879b05130ce6de9c9aa07465f89488b31a76248da2888"
    sha256 cellar: :any_skip_relocation, mojave:   "c8af00dfa6f60530bec05341d3e7fec0591a6dfcb88ba4c74f0bb31a243d330f"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  # https://github.com/fibjs/fibjs/blob/master/BUILDING.md
  fails_with :gcc do
    cause "Upstream does not support gcc."
  end

  def install
    # the build script breaks when CI is set by Homebrew
    begin
      env_ci = ENV.delete "CI"
      system "./build", "clean"
      system "./build", "release", "-j#{ENV.make_jobs}"
    ensure
      ENV["CI"] = env_ci
    end

    os = "Darwin"
    on_linux do
      os = "Linux"
    end
    bin.install "bin/#{os}_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end

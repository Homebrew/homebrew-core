class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.33.0/fullsrc.zip"
  sha256 "4a681b057598f1ebcdc7b943aba506bd942d7919b7c7fcb459a2c6d4ffdaab4f"
  license "GPL-3.0-only"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e5a997e76a3fa661cbdf75cf61e3e53e093451c2c5e9a1e55a16e6b8742fb55d"
    sha256 cellar: :any_skip_relocation, catalina: "a93fbe33a0f6feca011ea1f21f69f2d5d72be12cc4b2ca11f217e53ad1a09c72"
    sha256 cellar: :any_skip_relocation, mojave:   "bef936d8399cb135a7073b6983ee41b0fb41e967c893a92db785f5d319ea453e"
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

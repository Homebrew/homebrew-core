class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs.git",
      :tag => "v0.5.0",
      :revision => "92a0d14ee241fffd29603963cafb1c1bc9a0dcf8"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c9d6becbe0c703d259005f96bab5efa090efbf66328ac9a9102cb1f25d4d596" => :sierra
    sha256 "286f64272a8718e26353ffb07e206b8ae8fe26d1ec208c87619620447d0fef68" => :el_capitan
    sha256 "ff021e457dba610fc58390c259511ddc14577c6df7b23c16ca740ba51d749b43" => :yosemite
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

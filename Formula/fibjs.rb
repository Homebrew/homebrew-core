class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/en/index.html"
  url "https://github.com/fibjs/fibjs.git",
      :tag => "v0.4.0",
      :revision => "dbb0a18444d5d832c1181ed1ec277450ec220181"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0c8a49653f9993e993b8caa64b3a19645aaf19533b5c9f7efee335c31fb57a7" => :sierra
    sha256 "919cead204ad590b6b42d790b730c7cb2732905b582e64ec95e7cc3a264b1878" => :el_capitan
    sha256 "5849f74b5ae30ae1bb4bfd74f230aa85277d5a45b733ebb42a6a17aac4e55128" => :yosemite
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

class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.6.1/fullsrc.zip"
  version "0.6.1"
  sha256 "30959d2c87543cb9ade38b931de04947811e5ab74967ac8c8abadca3d8d47a12"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00d5b0d8e455e596d4082f36dea064b4e0d1f3ecea97969ee002543225246912" => :sierra
    sha256 "5ae3606ab7582f8b26a37194182e917448eaba97ceb03292a672d58044134cf1" => :el_capitan
    sha256 "d7ed1e0bc622754d75805c17d864c3fdcf3fcdd8d58ae844bb2e54e3422ab8a3" => :yosemite
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

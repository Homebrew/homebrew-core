class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.31.0/fullsrc.zip"
  sha256 "e5111ece8e6350f5d530d4b17003c2019be27017c5dec75c488587e942c502a0"
  license "GPL-3.0"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c123ec4d010a5f4912b5dccb3af1d83aed12f1678c9314360c08208aef8655b" => :catalina
    sha256 "014db4fa7314f35b7ba0ea76a0d77c6d6ca59d00e7ffd9e22cab12f7cad2993b" => :mojave
    sha256 "8830b25d963bed8bebab3e2be4024ed925c702ef4e28d1c5679ca9304f73f266" => :high_sierra
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

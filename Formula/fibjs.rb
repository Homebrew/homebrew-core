class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.31.0/fullsrc.zip"
  sha256 "e5111ece8e6350f5d530d4b17003c2019be27017c5dec75c488587e942c502a0"
  license "GPL-3.0"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "1d09edce8848d653f844e82001274a402eaab4ff16cad131753350d985a024ae"
    sha256 cellar: :any_skip_relocation, catalina:    "804d64c9c1d99dc5f94e9219f9fccee72745ec25f96a47a297f869b5504e6682"
    sha256 cellar: :any_skip_relocation, mojave:      "f833634da5af3a4596412cd06860b12d685b0e60ca2005ffb8968507d312feab"
    sha256 cellar: :any_skip_relocation, high_sierra: "10b5be3c5be1f1cb3ef9a905755491a17d84fe7d4453169717aa0ee5bd19d45d"
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

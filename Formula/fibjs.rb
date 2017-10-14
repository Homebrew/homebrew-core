class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.16.0/fullsrc.zip"
  sha256 "57bc3aa95eb85fcc0ee4809f4ba8d90691db65f53ffe5cbb17a48cfcb98adff4"

  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "612d7f1ca68bbca4cd4ab7ce2daac2116c271aeec35a8176d2979d52f92c95dc" => :high_sierra
    sha256 "c76ad4e8f703a2afc2f4d349306379a0cf5d2160df8aa89dfa73bf579f64bdeb" => :sierra
  end

  depends_on :macos => :sierra # fibjs requires >= Xcode 8.3 (or equivalent CLT)
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

class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "3900fb2f34107f4cc4015bc1f2277577e5b16fae10c39e556570c511cc0fca47"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9b567af56ef5feb35c3f978fe948e6ba323d646bf15f517adf9e4239d274754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3dd184c24d140fe2da4515589cdeb850d3b1ad8b25ea305f20d363cce8bdf28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b24aebd165650371fa9f4dcdc4ed6814ead546dbc85c6c23d3e9c112d18ebdf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5da4095b665078e856132095482abb9cab5e6169874fabdb3028a932361bf33"
    sha256 cellar: :any_skip_relocation, ventura:       "bec31420cdc3cb266d53aadc81ce26330e2ea66319bf4ccd97aff5a9bae08fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a79989704b19e9dd89204d3d03d94fff5c5c825dc8022efda54c52af5e20b9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110cdc103d242c92cec2fac8f92946e6e1e305ca8ff6027664dc3b1f9d2bcef4"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system Formula["gradle"].bin/"gradle", "--no-daemon", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix", java_version: "21"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end

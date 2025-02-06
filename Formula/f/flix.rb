class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "d3b9268cce0c7a0d88fa109be22a1f232368e44d39be2a0cfa72e41c5a52bc35"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fed48bde551863ee55d9303b860c147d07ec38ce2a587069576ac98b0c0bdef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d991f07ad8e22ea85e3b3f8a128615aa547255c872eee0d957ce8c3805951198"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aea0d3dee278b30bc1c01a76f766090a2847320410b7809704e82eacb3d0817d"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c05e4bd6923291b1bb58a39b772633a3415dd66000ae5dff76ed91377692a8"
    sha256 cellar: :any_skip_relocation, ventura:       "260a3e1333e326e69f19864650f5d7b5574353521d87aaf63172eb7f43e2faf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1c11e8a21a2835c873aa32bf844c7eed0390a91a253f586624be0f0adc94741"
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

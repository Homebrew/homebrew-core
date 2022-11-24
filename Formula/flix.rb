class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "437293fce5f401587f0ebbcea743781627869c1363727deb8e36a206daab373a"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d3dad97ca82100fac50985df86347d76546c91a63c081f3bd7b452766a3e87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47dc3504a033cfc807e3bdbde3d163bffce696fed4ed10360526164e3eb6457c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54257afc3ab5b24da2bcf2d8868ed1bf26f6c43fba5851930371e06795ffb85a"
    sha256 cellar: :any_skip_relocation, ventura:        "d5cace651fd02333d835f89fa41faab7a3a72fee225673854a76aa4de6397afe"
    sha256 cellar: :any_skip_relocation, monterey:       "03de699152dc657636d380aba003b9d3be468019a727725011581d756620e03a"
    sha256 cellar: :any_skip_relocation, big_sur:        "517ab78459a059ff85c5b5783a7afdaaae015c45b67757525f3cb898c2726516"
    sha256 cellar: :any_skip_relocation, catalina:       "687ef3b9c738f19df14c27e226e2988a934438fee7093792b9453515c452e768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f8db335366cdd42eb37bb0db858a2a6d3908e0dfb71ed651584b20a0ed7d4da"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin/"flix"} run")
    assert_match "Running 1 tests...", shell_output("#{bin/"flix"} test")
  end
end

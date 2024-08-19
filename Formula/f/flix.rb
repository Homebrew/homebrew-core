class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "ef705b5940d25a0bea1d015cfbc017e4bb34c9dbee55016504ac36380031087a"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f203f4ef9742562e603ab8832b984f7a52f6dc7804ca4e616675298e48b2ab8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa03c09cf7a2af4868ffec58bc292bc661fb6c66c0f48522dec8c659c0866496"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec5e1e43936045c15040eec5bc3461a1f58d68b0b3bf240752d891269eb41a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "79b55d3675d09a2bc7fbb6a70a05b5667c5bda1d120d5aa6ac7a4bca5e6a6c5b"
    sha256 cellar: :any_skip_relocation, ventura:        "2536d2b0591bc401323be52c6ba71928ba516025cf11273eac90d4486c48a87e"
    sha256 cellar: :any_skip_relocation, monterey:       "ee8319cbc344cc1c064123e9fda6f8e0a70ddce37367fa971679db0865bc0a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24191e0abeb9fa845d7c960d2969cfa6ce7e197075133d6da839213388de0db0"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk@21"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix", java_version: "21"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end

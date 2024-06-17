class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "9f6d0ff41c4531cb4883e4a34fa027ee3f4f43363034e58abb282a314aa708cc"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "269d450999a6d3a516ac32a73509875092c682118fa21d91459942a21dcf9680"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7925dc2b5511fe578dda6cec7bb234217a5a21639a672bc02b75e16e411bf718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393b40ef5aa60976dc99903b907cd862737b9d2ff7ecc50da2d990a921b5c9b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "00d27e18023dd069ba28abf3a3721c92f1b4b669eb813c6664bbd24cb6bcb3ec"
    sha256 cellar: :any_skip_relocation, ventura:        "b9373a21d8c6ebc399aa28182fb852d857e6dda1ebe2be1d6996f80bbe47e829"
    sha256 cellar: :any_skip_relocation, monterey:       "06971c52824d53f316b7fcb4b758b6c052df9ea10772f6e280cad50a8a79b730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018ca3af4378e4c2f0c07ff7f8cc51689cf8b295d45d0f184688c79f8b8fe040"
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

class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "20101818e32245f40a0392c6cda4f89a81d5041c3a0500fc7f0459b1c43a9820"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "332af4f28ecb0a6f51a5e3ac9741857951740bd8d71f342bea657c2332824468"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "483a5dda730d1845f01999e5f55f576affcd9875a4ec410b14dbf34f414ca872"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5328e132b36cdc9c91d274100b29c641d1929d8674b7e58afac8fd5f6b9435"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0f813aeb06df191158875ae8a77f80f58bb9b0e45604d3329b9c44c9c9bb146"
    sha256 cellar: :any_skip_relocation, ventura:        "0569edb6b052a7a94e3105e4cfbda6b621d6c56ca5384a2c3202d300c6c79487"
    sha256 cellar: :any_skip_relocation, monterey:       "003967171d48a3dd606a6bb8a4200f82a3cc4d4bed86be2ef4cff87fe8225d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9180a441c385767df4fcbe8412aac69ff16882d96a4278861af81dff25f858b6"
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

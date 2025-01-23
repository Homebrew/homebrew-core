class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "84d66d472c54aadb47ba67cf35322b36cef24185440e5493e38c8265202b9631"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e7260c556e1d04ea446c7e941fecf4867bbcbe4542cd33feec379633fe604b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73749b4ab033ac9bfcdba23b2f3e2c773d366831bf82be17e24fccfc5b06b167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "949e295ca0a979a9b5b075f15c1909cffa09cd1e596dd8e0366c6db83461af33"
    sha256 cellar: :any_skip_relocation, sonoma:        "46047d3022975ae641830d59dd43aaa833903d372d508b838f7e92574af4b19c"
    sha256 cellar: :any_skip_relocation, ventura:       "511decfa4fb55ce353a1d9b8ecdd23fc2eb1c90e030928abf31a967f816c32be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb6df7cfce51e82f1b0697b8c2f8544616435f26f67f64a25f852898b9d54e3f"
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

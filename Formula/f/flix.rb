class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.76.2.tar.gz"
  sha256 "59b54b53cad14c9928572106d172aa4908797c2c75e9dc6ed30c23abe88ca31b"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfbbfab540ba295394e2d809de926b3b8b5df50c3571dd4b244fb1027eb404fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b774ef7f79417a162c053ac35086694727cbc76857556e3ca3c602a02fd88211"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd68ac376da4ccf350ae42eab5de89e837f3631d8391f94d55b002c9cb7cc183"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c08ce86a56ed977d80d207304f10047addc7e814570f8f00ed79087b7966bc28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b288f18fc299fa68a2fc027e92a67627d70c0039613170c757d4e7e6f4098bd3"
  end

  depends_on "mill" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mill", "--no-daemon", "flix.compile"
    system "mill", "--no-daemon", "flix.assembly"
    libexec.install "out/flix/assembly.dest/out.jar" => "flix.jar"
    bin.write_jar_script libexec/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end

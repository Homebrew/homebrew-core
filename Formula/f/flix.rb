class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.69.2.tar.gz"
  sha256 "dbb82cf1188f1d8727ae0dabeb01982b174d0c05cbc2f20aefe843f3f26640c0"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2725fb565a34d5ec4a9e0500f47e21677ebeff0f8616bf0c39a689b5ea5a2fa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e586edfa29925b5fb8e07525e29f76ecacf3ae8780c99bfdf3b3794c7a5df75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec11f1126b676cc21d390ccd3d55a9dcf811e8184564aee679be916c3babc12"
    sha256 cellar: :any_skip_relocation, sonoma:        "427dc74d3ad2fffb79ba5751652be7ca981fe2bc19b976779399953e5c6d78c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a88e4035a5abacd08aefd7dd35675a520c8fc296a08908f7f29ab89b7798b1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb29a077c0f868c8d75e316cabb5c2b0891b7d55604bf2aec6e14d04bbcd4d4"
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

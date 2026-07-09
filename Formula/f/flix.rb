class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.75.1.tar.gz"
  sha256 "69379b9e2b6cf0ae0de8581ca768f437ea70ed9437179c753769e24a5eab59ab"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "245c2b1dd77986f4e9db6e4509687a717331e94c6143425204fda724bc0aba85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acaec268b1cdecb2f8d6fc26864c4a1cfe1da1d68f0063c843aaaf697de1014a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad387ed2e9b4598d3e8f4889b75c33bf5e99f5b24e7a30d8889606dd85345707"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b6afbcd3c6ffafdfabce29c01b38a1aa92135d53a9e828b3672487d35ad26ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b09f954eb3f0e26175fd9a9db983b722a3220d03eb5cc2a3189157d5aa5a1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc2ae17ebcbcc4992fa5249f5b0a59d64c313130b7ac9e8409578cab2c830e3f"
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

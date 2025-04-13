class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "7f7d58589d765570458928d2bf3e4150e64b37c1f8b27de12467723adacdb5a3"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adedd8c4b78995253197b86bfc7cee5bbc043746a1ec943f15ca4083efd14a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca6e97b951b852a5feca14c25f54fc587c059aa4b038197ab2ff12d7d4027ca2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6d91e77ac66df3e2c41a63edc4f2400fe40e9666c93bf3c76afa2aeed0fcad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "428a655549581a7622c376bd8bd3492ef0398f8fde85bce75d15c768cf93caba"
    sha256 cellar: :any_skip_relocation, ventura:       "21677299ea1cf20fbc45028620802166d874dd6f7f232941a9e079b9dcb14a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0073adeb23f97f31095d590ae5f4c8ae0a65a9b9290197f8632084bcce007425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f22198dde8ff1d40f54409f4f5973e71aa2f4a3c1aafca77def9c1ba4e8970f"
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

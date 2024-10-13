class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "81792034d88d9c4ed07158e032e6dbe3dc583455e8bca871e497dc708f859f2d"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc741796f8e545cbe9dc33e70c6e688eb6d31b11f46d1a91155eb16fdbc0d1fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "894dda491aff6df6893ec5ee1e2ac0c878fe33780744fd504a1601a0667147cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2767b9ef3cf2c2a038b8072a40b81edacd78eb133c9511495a240d662a3985a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a0f3399e0c18999a66cc047f655eb21e5446853f8c0f67ba0063c181da4163"
    sha256 cellar: :any_skip_relocation, ventura:       "c1745f24fadac2548ac9232d7aa808bd428ab38387777cd221568e6f6b43c9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a6a2d19c0e02e7a190b1d409b8138d4109b73d25b23e6e6248c462b0279e25"
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

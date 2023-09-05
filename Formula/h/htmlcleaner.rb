class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.29/htmlcleaner-src-2.29.zip"
  sha256 "9fc68d7161be6f34f781e109bf63894d260428f186d88f315b1d2e3a33495350"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c69fec74c6bdd85bc1e50f84ca5530753edd8f3138658ada3afbe5a3f5d6120d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d51522c4694c19381009f5f0566c3b99ce3db5375bbcb0378530ef73e100906d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7d35a9ba43bece23688f19a0bad2066609dbae23c1f1413d170ebf66201e126"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c18a92a98adb2245192c0b300729d74968f6ce4a62308e27d0c70e7600ec8d"
    sha256 cellar: :any_skip_relocation, monterey:       "da4541f544b599317e82d02ec9eb4a02e780946eca8f0d7a5f0a017e5737a841"
    sha256 cellar: :any_skip_relocation, big_sur:        "42e661553a128f210c22e5c0a5c6a90ce52f2242708d61f7e8d325ee97e09352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f795c5d9639319b32b2f4ae9a12e03272e52969b2d259f0f3916c9883b035ba"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install "target/htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end

class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.24.tar.gz"
  sha256 "252f3223edb8e4e77a5e410f5acba0a9c481a074d392c6bc8ed98119b5364ede"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "693e5dc4f4424b3a38797ca8cfefebee998c157abc23e7f2aee9d86f719f3812"
    sha256 cellar: :any_skip_relocation, catalina:     "64abc4230c722c02801160e8ed6640c6dba29817ca80f3832f58e47e2ceb58ad"
    sha256 cellar: :any_skip_relocation, mojave:       "705ebbe2c1b1aafb4ce5995b132b7e65471ab5e24d4889981d1779018b7e610b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "35369919495a7d1f544e168c807b8f423d6fa586bc057d56a13328cb0754249d"
  end

  depends_on "maven" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  skip_clean "libexec/ext"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end

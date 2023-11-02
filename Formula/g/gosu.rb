class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "654eaa32121b39419cc67ba1c4c5208df00fddb85fe36de8f3d81cb1a400c661"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "cfa06e74d45922c8c455829273ed19ee5afb3858dfaebcb0a32896f8a9bb5946"
    sha256 cellar: :any_skip_relocation, monterey:     "c3ee2e77dd6f53dc8dddbacfd55eb157f654ceb208073d38c3ba0485f621a0a2"
    sha256 cellar: :any_skip_relocation, big_sur:      "693e5dc4f4424b3a38797ca8cfefebee998c157abc23e7f2aee9d86f719f3812"
    sha256 cellar: :any_skip_relocation, catalina:     "64abc4230c722c02801160e8ed6640c6dba29817ca80f3832f58e47e2ceb58ad"
    sha256 cellar: :any_skip_relocation, mojave:       "705ebbe2c1b1aafb4ce5995b132b7e65471ab5e24d4889981d1779018b7e610b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "35369919495a7d1f544e168c807b8f423d6fa586bc057d56a13328cb0754249d"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

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

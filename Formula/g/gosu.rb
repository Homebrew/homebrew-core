class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "f8cc32aa8a40bdf1c28db52c5198218514b511ba31cdd5e70eb5817a490f0182"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a9fbc740652f079d012dc919d88e82144a1cd3eea461b4568dbbe91aa5b4aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "832bb0b6f774304d98fc6742bdb63da9eb4d85aa93693604cb23904885583604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47030e23755e85a979adc972a2665889fc52f627294c95ba123a9f3549c7c99"
    sha256 cellar: :any_skip_relocation, sonoma:        "917a9ae63584e4762ee76fdf7fb35c1ed0ce0342a39a96f6ed32617093f868d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8ff5d1b2c5b5df671572bb9addf121151ccebbf2562f1a622c016c4b12595a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277eb63cbd485e59653c4d04a8acda5b734add1ea2a3792692226fd09f425d35"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  skip_clean "libexec/ext"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("11")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end

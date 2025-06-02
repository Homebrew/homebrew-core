class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "63156dcfada79e9809d006fe097283d397b95ed73cf6e2da29bea1a822ffeee3"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e12a8df75327b7a6f678e948de6e54c533b3268b6e2918c04fbe32ebf714008d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6717261ce99cace9a0f5b474aa4016dc42345e2e1d941bd9c23664e3c5f80f2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7027e597cce5538becfa6e451faedc52d3ab1c85c175e5ba7df2e932e5e39811"
    sha256 cellar: :any_skip_relocation, sonoma:        "64a74e0f12b66a7be551dfe944c9d85cb4495d47dffac0d346e40696398efb67"
    sha256 cellar: :any_skip_relocation, ventura:       "0cae3bf8c24488c410d12773bc1e6f6ca566579ec1ced6831a9919ad31b842a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f7ee715e0a2cd1002350f06f5c99f3cfbbb25c88d41930b9347430cff9683f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aff995dbd2e47d5b759424448edf3a44e8005cc4ecbf1ac4a84510e6a2a37f6"
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

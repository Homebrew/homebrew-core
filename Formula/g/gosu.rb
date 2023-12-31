class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.17.6.tar.gz"
  sha256 "7211ac8ca01b50d5900e8f30b52fb218d9b6cae4936efc3711f295ffb30157b1"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf22d3a04f1a09e144cf09e3febd9b8d327d2f1c2d80505a97a41fde8f65b82f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fe16e31502a4e0ccecb6f8d6ed5d0d64db068ce66eddd580ce35be1d49c51b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f1545678d511cb9d6be1c4e6809bd245e745b8038efb73e47de02dd6cb9c119"
    sha256 cellar: :any_skip_relocation, sonoma:         "5061bcc3951f19a8a2449f65ec4fb7cd549b2b3c37162de391eb9f5cf08a1f67"
    sha256 cellar: :any_skip_relocation, ventura:        "06a148d96456a5b892738762953eb2d4b9772dac04899519ef37f60a3a563370"
    sha256 cellar: :any_skip_relocation, monterey:       "5bcfd55c5df56d3931ae8c6fe8c7fd3df838b6d5326ce02e00cd2c9bbf089307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a5bc04850751c0399f21d0e5f74c38fd597882c7d2eaf520e0cb08e70517dd1"
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

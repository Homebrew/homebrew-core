class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "22e756ece97b9139f04d75dd19e61e13d923a8b777e8f457606a32e25c2e8447"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484794e12ddc3dd5531947172771bfa1af355d2b6c5d835cc12d2548f09c0af4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e70cb5eead066e5d9b73faebbbc4c918f737148cf31d363b18c3d1e0090a0a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afd867fcec0ad217b9d4edcbac9657fbe280527dfe85e3c48cb5fa425b7f9fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "65094685513b715aa447c2b5221ebbae4a5fe121b39d890988f51c23581900fc"
    sha256 cellar: :any_skip_relocation, ventura:       "0dfb0b64d9e2a8f95bcd5efd19cf945649492805daae70fd7db2ec8d1955bf8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b45d808b97ff6a2e5d7df62112c977a43d1a826f64cc511ee38f83e3019f0271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910d6e90cbe2a448fe69b907d2af9a86cb6d4996d31a1b2c7406a751f0a3f850"
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

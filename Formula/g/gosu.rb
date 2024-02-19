class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.17.8.tar.gz"
  sha256 "143d59e7f410d51267e36a1b7eda10de69149242c42ef7ed4c35750e3d40a177"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d2b83d1a99f89c190476e0935201d4df96ebcdad1ea97a4384710d49a958fd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da819f17672f748e145e6b09b53079c3bdb760a91b221efc39d2ae7436db8d96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77491c733524b005ea8e832e641749f655338a89d70f66fedb71cdae4ddbd71e"
    sha256 cellar: :any_skip_relocation, sonoma:         "878e4298790d616448ae4ea843023269fe58a4eabe6fb4beb5626c1f45974325"
    sha256 cellar: :any_skip_relocation, ventura:        "82528317736ec382b3c9e135d05343b3143c3c2c136b6257f1a40047aab6cfdf"
    sha256 cellar: :any_skip_relocation, monterey:       "66c2cad8b2ac16bbd311ebfa13a501ca541072fa9ff124d63c77b1a5c69a823c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4ef28a442afd6c626fdc09bc46cc94740d263bb93ca9f71a003d2a56573259"
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

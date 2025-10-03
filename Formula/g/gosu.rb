class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "59b74e4613b8e7fd605909d5828b6c625d24a2f72b3d5d61dbbe8cfd7197b96f"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa8992262daf0a97b8a06934e88e64590ff215e7ad73d3f81680936b9155463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9efecd3baf76b39e78a06982e5447a99e93a060c0848ba0d817dd8fabdeecbf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80ac6cce998471735db8e8268840930e2fc1012cacb0245acdf5e5d83a284b24"
    sha256 cellar: :any_skip_relocation, sonoma:        "36e87f4085b4fa1d7cc982886fdb8d519cd86f148a68a858c0ffd53681b89e68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6a9b9693b2604151469a90994b255186ae135aa50d75f753f8a82e15f86b1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b3f19955924660791f2e57b2bb19f03a59d123bdabcc474469f96141e4e5241"
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

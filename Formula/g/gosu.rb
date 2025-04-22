class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "4f540f6c98f66168d5c323ff9b136860233ae2db48ab5f6861516c6841921620"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce3bd4b986b00632ac11d3f970b629a2110ad1fe0aaea20fb2448b03011851b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "209b02d93ac370d283ebeccce79e39ab9f8100bee42379755c812ce92b81735b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f4e42871312f4ed3cb7f475308eaf832ad586ddb83fdcd40139fe199f5f7e08"
    sha256 cellar: :any_skip_relocation, sonoma:        "da90b986122804dc3258fe11d8302c4245b2522f791c79571b2ac9a7448acfb9"
    sha256 cellar: :any_skip_relocation, ventura:       "53c421965f11dafb90264a8a010cb3c10f674fe5e0cc12309281d8293201add7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71f9963f524b5008a13c73206aa11e3a2a96937d0c7b117a4fb654881f35a90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59fa04366877eeedabc0c8abd1c588c1a6d119fab235a38b466fedcb1cea1ede"
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

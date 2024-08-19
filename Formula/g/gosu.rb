class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "442ce2abf0456794b3868c074d1b565dfd60f41bad281ed456b5bc8dd4900f1b"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd65dfda5a9a3fb841b671a3c54bdc64e428c5fcdf5d90bc2d315308a4193881"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4902bcc8cde984abf7c8561062b27d318327dd3867fd04c8111a1984b30290"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90f2c2db7beb4253492b8075b4c27459666cc4cc80930906961c73d241b2a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f32bf5a6726945d2b6bf12d90e0e7929f78fbf75dbacef330eb0c8993af49aa"
    sha256 cellar: :any_skip_relocation, ventura:        "a95b683047f92a0e8b935b0eaf73f69265d3b433bac6349b19bf31c01bb3be1d"
    sha256 cellar: :any_skip_relocation, monterey:       "b2338123e7a6da31222b5f428b35a622aea12608428cdab14da003882feb7a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91afe00d22c7ccd7f6fa42fc17aa68f318ec5cafad3a176d92a868be77b663e"
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

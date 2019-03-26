class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.13.tar.gz"
  sha256 "791c6d423f90c3161b568e3b907bc27802f59f60bb63719845c7c9814e9b3bb4"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ffaea191fee11809de6ea6e34af7c66517b580ec3e734025b0bcfcebaaa705b" => :mojave
    sha256 "761367a27bf9f1370a6d6494e31ee526087c6dcea671280872e5afbf047e9801" => :high_sierra
    sha256 "c332bae630d5048078996f3a6bf538237c39b62343310f777cfb05d8b5aef2d9" => :sierra
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  skip_clean "libexec/ext"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

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

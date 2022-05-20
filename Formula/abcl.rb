class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.9.0/abcl-src-1.9.0.tar.gz"
  sha256 "28b2b05216b57eddcf44fb23c18f2a382a3d8c1a7103fc150c2592200840b68a"
  license "GPL-2.0-or-later" => {
    with: "Classpath-exception-2.0",
  }
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  livecheck do
    url "https://abcl.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d9f50b438f54aab741cdf8d5d5e90e088dc8ba9a934fc9c21ec2f2c09fbbb58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63e51bb0f8b346ee6e9791975d1877a9d0baf6e91014bda48cd1ea61a1e326e9"
    sha256 cellar: :any_skip_relocation, monterey:       "21ad5dbdcbd2c93a7d2264e736751e6cb5f8f8c32fc69c112cf7d754b40af064"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff1a64297486a136b75a555b3a434d6441979586a8679f3590cfd03b4d0b50c"
    sha256 cellar: :any_skip_relocation, catalina:       "d474e6f49fe69de692a293bdfb37110674f58bc151b1e3b38b5011b8f0d7d41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e047042de4a2b4751ad47c95d3f9f8ec412bd2ed713b85e921381bed04f0ff61"
  end

  depends_on "ant"
  depends_on "openjdk"
  depends_on "rlwrap"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "ant", "abcl.properties.autoconfigure.openjdk.8"
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write_env_script "rlwrap",
                                  "java -cp #{libexec}/abcl.jar:\"$CLASSPATH\" org.armedbear.lisp.Main",
                                  Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match(/"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip)
  end
end

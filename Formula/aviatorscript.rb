class Aviatorscript < Formula
  desc "Lightweight, high performance scripting language hosted on the JVM"
  homepage "http://fnil.net/aviator/"
  url "https://github.com/killme2008/aviatorscript/archive/refs/tags/aviator-5.2.4.tar.gz"
  sha256 "92b6388ec58da2d987b617aeee204ea54c5a9f0a1d768abdaec9c610555027a5"
  license "LGPL-3.0-or-later"

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "package", "-DskipTests"
    inreplace "bin/aviator", /export AVIATOR_VERSION=".*?"/, "export AVIATOR_VERSION=\"#{version}\""
    chmod "+x", "bin/aviator"
    libexec.install "bin"
    aviator_dir = libexec/"self-installs"
    aviator_dir.install "aviator.jar" => "aviator-#{version}.jar"
    env = {
      JAVA_HOME:    Formula["openjdk"].opt_prefix,
      AVIATOR_HOME: libexec,
      AVIATOR_DIR:  aviator_dir,
    }
    (bin/"aviator").write_env_script libexec/"bin/aviator", env
  end

  test do
    (testpath/"hello.av").write <<~EOS
      p("Hello, AviatorScript!");
    EOS
    assert_match "Hello, AviatorScript!", shell_output("#{bin}/aviator hello.av")
  end
end

class KotlinDebugAdapter < Formula
  desc "Kotlin/JVM debugging for any editor/IDE using the Debug Adapter Protocol"
  homepage "https://github.com/fwcd/kotlin-debug-adapter"
  url "https://github.com/fwcd/kotlin-debug-adapter/archive/refs/tags/0.4.3.tar.gz"
  sha256 "9ad4db7e8877ed73d0b14c682f8bb8c4aed62918e3d936f0eb368052e2de2a8d"
  license "MIT"

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":adapter:installDist"

    libexec.install Dir["adapter/build/install/adapter/*"]

    (bin/"kotlin-debug-adapter").write_env_script libexec/"bin/kotlin-debug-adapter",
      Language::Java.overridable_java_home_env("11")
  end

  test do
    output = pipe_output("#{bin}/kotlin-debug-adapter", "", 0)

    assert_match(/^Content-Length: \d+/i, output)
  end
end

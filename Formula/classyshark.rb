class Classyshark < Formula
  desc "Executables browser for Android, Java and Kotlin"
  homepage "https://github.com/google/android-classyshark"
  url "https://github.com/google/android-classyshark/releases/download/8.1/ClassyShark.jar"
  sha256 "73f0f8854a564d0eec4550fd69ebc239a38ae82f57e95cffb45890ba1b2e8098"

  head do
    url "https://github.com/google/android-classyshark.git"
    depends_on "gradle" => :build
  end

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    if build.head?
      chdir "ClassySharkWS" do
        system "gradle", "clean", "fatJar"
        libexec.install "build/libs/ClassySharkWS-all-1.0-SNAPSHOT.jar" => "ClassyShark.jar"
        bin.write_jar_script libexec/"ClassyShark.jar", "classyshark"
      end
    else
      libexec.install "ClassyShark.jar"
      bin.write_jar_script libexec/"ClassyShark.jar", "classyshark"
    end
  end

  test do
    (testpath/"Test.java").write <<~EOS
      public class Test {
      }
    EOS
    system "javac", "Test.java"
    system "jar", "cvf", "Test.jar", "Test.class"

    expect = <<~EOS
      Test.jar - 1
       ??Test - 1
    EOS
    assert_equal expect, shell_output("#{bin}/classyshark -methodcounts Test.jar")
  end
end

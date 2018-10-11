# For `pour_bottle? do` block in main formula body below:
class XcodeCLTRequirement < Requirement
  fatal true

  satisfy(:build_env => false) do
    MacOS::CLT.installed?
  end

  def message
    <<~EOS
      This software requires the Xcode CLT in order to build.
    EOS
  end
end

class Openjfx < Formula
  desc "Open-source, next-generation Java client application platform."
  homepage "https://openjfx.io/"
  url "https://github.com/javafxports/openjdk-jfx/archive/11+26.zip"
  sha256 "71ac64ec75c0ee36fbfa8335492b38d88843a33ecd7e3a10793507fd248b829a"
  version "11"

  # I'm not sure if this is actually the case, but better safe than sorry…:
  pour_bottle? do
    reason "The bottle needs the Xcode CLT installed in order to run.  "
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "ant"
  depends_on "cmake" # For `javafx.web`.
  depends_on "gperf" # Also for `javafx.web`.
  depends_on "gradle"

  depends_on :java => "11"
  depends_on :xcode # '>= 9.1' in the build instructions, but I'm testing on my current system
                    # first.
  depends_on XcodeCLTRequirement

  def install
    # java_home = ENV["JAVA_HOME"] # Possibly not necessary, as it may be auto-detected…?
    # ENV["JDK_HOME"] = java_home # Same here?
    # ENV.prepend_path "PATH" java_home/"bin" # I think `brew` may handle this automatically…?
    # ENV.prepend_path "PATH" Formula["gradle"].bin # Ditto for this?
    # ENV.prepend_path "PATH" Formula["ant"].bin # Same here?

    system "gradle"
    prefix.install Dir["#{buildpath}/build/modular-sdk/*"]
  end

  def caveats; <<~EOS
    In order for Java programs to find this library, you'll have to add it into their classpaths.
  EOS
  end

  test do
    # A more extensive test would build something against _all_ JavaFX modules, but this will do for
    # now.
    #
    # Adapted slightly from the example at `https://openjfx.io/openjfx-docs/#maven`:
    (testpath/"HelloFX.java").write <<~EOS
      import javafx.application.Application;
      import javafx.scene.Scene;
      import javafx.scene.control.Label;
      import javafx.stage.Stage;

      public class HelloFX extends Application {
        @Override public void start(Stage stage) {
          String javaVersion = System.getProperty("java.version");
          String javafxVersion = System.getProperty("javafx.version");
          Label l = new label("Hello, JavaFX " + javafxVersion + " running on Java " + javaVersion + ".  ";
          Scene scene = new Scene(l, 640, 400);
          stage.setScene(scene);
          stage.show();
        }

        public static void main(String[] args) {
          launch();
        }
      }
    EOS

    system "javac", "--module-path", prefix, "--add-modules=javafx.controls", testpath/"HelloFX.java"
    system "java", "--module-path", prefix, "--add-modules=javafx.controls", testpath/"HelloFX"
  end
end

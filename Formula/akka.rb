class Akka < Formula
  desc "Toolkit for building concurrent, distributed, and fault tolerant apps"
  homepage "https://github.com/akka/akka"
  url "https://downloads.typesafe.com/akka/akka_2.11-2.4.20.zip"
  sha256 "6f6af368672640512f8e0099a5d88277f4ac64de7d4edd151411e6a80cc78d0f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1b321e709c3c0165d5254fa009f2c8596e7803cf1c0fb8e9753562910c34239"
  end

  # https://github.com/akka/akka/issues/25046
  deprecate! date: "2020-07-09", because: "is recommended to use Akka with a build tool"

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm "bin/akka.bat"

    chmod 0755, "bin/akka"
    chmod 0755, "bin/akka-cluster"

    inreplace ["bin/akka", "bin/akka-cluster"] do |s|
      # Translate akka script
      s.gsub!(/^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{libexec}")
      # dos to unix (bug fix for version 2.3.11)
      s.gsub!(/\r?/, "")
    end

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"src/main/java/sample/hello/HelloWorld.java").write <<~EOS
      package sample.hello;

      import akka.actor.Props;
      import akka.actor.UntypedActor;
      import akka.actor.ActorRef;

      public class HelloWorld extends UntypedActor {

        @Override
        public void preStart() {
          // create the greeter actor
          final ActorRef greeter = getContext().actorOf(Props.create(Greeter.class), "greeter");
          // tell it to perform the greeting
          greeter.tell(Greeter.Msg.GREET, getSelf());
        }

        @Override
        public void onReceive(Object msg) {
          if (msg == Greeter.Msg.DONE) {
            // when the greeter is done, stop this actor and with it the application
            getContext().stop(getSelf());
          } else
            unhandled(msg);
        }
      }
    EOS
    (testpath/"src/main/java/sample/hello/Greeter.java").write <<~EOS
      package sample.hello;

      import akka.actor.UntypedActor;

      public class Greeter extends UntypedActor {

        public static enum Msg {
          GREET, DONE;
        }

        @Override
        public void onReceive(Object msg) {
          if (msg == Msg.GREET) {
            System.out.println("Hello World!");
            getSender().tell(Msg.DONE, getSelf());
          } else
            unhandled(msg);
        }

      }
    EOS
    (testpath/"src/main/java/sample/hello/Main.java").write <<~EOS
      package sample.hello;

      public class Main {

        public static void main(String[] args) {
          akka.Main.main(new String[] { HelloWorld.class.getName() });
        }
      }
    EOS
    system "#{Formula["openjdk"].bin}/javac", "-classpath", Dir[libexec/"lib/**/*.jar"].join(":"),
      testpath/"src/main/java/sample/hello/HelloWorld.java",
      testpath/"src/main/java/sample/hello/Greeter.java",
      testpath/"src/main/java/sample/hello/Main.java"
    system "#{Formula["openjdk"].bin}/java",
      "-classpath", (Dir[libexec/"lib/**/*.jar"] + [testpath/"src/main/java"]).join(":"),
      "akka.Main", "sample.hello.HelloWorld"
  end
end

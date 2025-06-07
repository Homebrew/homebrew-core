class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java using AsyncGetCallTrace + perf_events"
  homepage "https://github.com/async-profiler/async-profiler"
  url "https://github.com/async-profiler/async-profiler/archive/refs/tags/v4.0.tar.gz"
  sha256 "7beb736868af485d6b0b624e42141f78df0ca8403188adc17965b7153261aa55"
  license "Apache-2.0"
  head "https://github.com/async-profiler/async-profiler.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "openjdk" => [:build, :test]

  def install
    args = []
    args << "COMMIT_TAG=#{Utils.git_head}" if build.head?

    system "make", *args, "all"

    bin.install Dir["build/bin/*"]
    lib.install Dir["build/lib/*"]
    libexec.install Dir["build/jar/*"]
  end

  test do
    output = shell_output("#{bin}/asprof --version")

    if build.head?
      assert_match(/^Async-profiler #{version}-#{Utils.git_head}.+/, output)
    else
      assert_match("Async-profiler #{version}", output)
    end

    (testpath/"Main.java").write <<~JAVA
      public class Main {
        public static void main(String[] args) throws Exception {
          Thread.sleep(Integer.parseInt(args[0]));
        }
      }
    JAVA

    ohai pipe_output(
      "#{Formula["openjdk"].bin}/jshell -q -",
      "System.out.println(System.getProperty(\"java.io.tmpdir\"))",
    )

    pid = spawn Formula["openjdk"].bin/"java", "-XX:+StartAttachListener", testpath/"Main.java", "100"
    begin
      ohai shell_output("bash -c 'lsof -p #{pid}'")
      sleep 1
      system bin/"asprof",
             "-d", "2",
             "-f", testpath/"test-profile-via-attach.html",
             "jps"
      assert_path_exists testpath/"test-profile-via-attach.html"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    system Formula["openjdk"].bin/"java",
           "-agentpath:#{lib}/libasyncProfiler.dylib=start,event=cpu,lock=10ms,file=test-profile-via-lib.jfr",
           testpath/"Main.java", "2"
    assert_path_exists testpath/"test-profile-via-lib.jfr"

    system bin/"jfrconv",
           "-o", "pprof",
           testpath/"test-profile-via-lib.jfr",
           testpath/"test-profile-via-lib.pprof"
    assert_path_exists testpath/"test-profile-via-lib.pprof"
  end
end

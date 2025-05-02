class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java using AsyncGetCallTrace + perf_events"
  homepage "https://github.com/async-profiler/async-profiler"
  url "https://github.com/async-profiler/async-profiler/archive/refs/tags/v4.3.tar.gz"
  sha256 "50f65033df0b999d0ae80c82d09827b595ad06051406ff7ec322fd1a40c1d328"
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
    # Set JAVA_HOME for tools that need it (like jfrconv)
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    # Verify version output
    output = shell_output("#{bin}/asprof --version")

    if build.head?
      assert_match(/^Async-profiler #{version}-#{Utils.git_head}.+/, output)
    else
      assert_match("Async-profiler #{version}", output)
    end

    # Create a simple Java program that sleeps for testing
    (testpath/"Main.java").write <<~JAVA
      public class Main {
        public static void main(String[] args) throws Exception {
          Thread.sleep(Integer.parseInt(args[0]));
        }
      }
    JAVA

    # The profiler can begin started as a JVMTI agent
    agent_lib = OS.mac? ? "libasyncProfiler.dylib" : "libasyncProfiler.so"
    system Formula["openjdk"].bin/"java",
           "-agentpath:#{lib}/#{agent_lib}=start,event=cpu,lock=10ms,file=test-profile-via-lib.jfr",
           testpath/"Main.java", "2"
    assert_path_exists testpath/"test-profile-via-lib.jfr"

    # JFR converter can convert the JFR file to pprof
    system bin/"jfrconv",
           "-o", "pprof",
           testpath/"test-profile-via-lib.jfr",
           testpath/"test-profile-via-lib.pprof"
    assert_path_exists testpath/"test-profile-via-lib.pprof"
  end
end

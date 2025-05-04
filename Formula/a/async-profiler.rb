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
    args << "CC=#{ENV.cc}" if OS.linux?

    system "make", *args, "all"

    bin.install Dir["build/bin/*"]
    lib.install Dir["build/lib/*"]
    libexec.install Dir["build/jar/*"]
  end

  test do
    assert_match "Async-profiler #{version}", shell_output("#{bin}/asprof --version")

    (testpath/"Main.java").write <<~JAVA
      public class Main {
        public static void main(String[] args) throws Exception {
          Thread.sleep(8_000);
        }
      }
    JAVA

    pid = spawn Formula["openjdk"].bin/"java", testpath/"Main.java"
    system bin/"asprof",
           "-d", "2",
           "-f", testpath/"test-profile-via-attach.html",
           "jps"
    assert_path_exists testpath/"test-profile-via-attach.html"

    system Formula["openjdk"].bin/"java",
           "-agentpath:#{lib}/libasyncProfiler.dylib=start,event=cpu,lock=10ms,file=test-profile-via-lib.jfr",
           testpath/"Main.java"
    assert_path_exists testpath/"test-profile-via-lib.jfr"

    system bin/"jfrconv",
           "-o", "pprof",
           testpath/"test-profile-via-lib.jfr",
           testpath/"test-profile-via-lib.pprof"
    assert_path_exists testpath/"test-profile-via-lib.pprof"
  ensure
    Process.kill("TERM", pid)
  end
end

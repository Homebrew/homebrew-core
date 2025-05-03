# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class AsyncProfiler < Formula
    desc "Sampling CPU and HEAP profiler for Java featuring AsyncGetCallTrace + perf_events"
    homepage "https://github.com/async-profiler/async-profiler"
    url "https://github.com/async-profiler/async-profiler/archive/refs/tags/v4.0.tar.gz"
    version "4.0"
    sha256 "7beb736868af485d6b0b624e42141f78df0ca8403188adc17965b7153261aa55"
    license "Apache-2.0"
  
    depends_on "cmake" => :build
    depends_on "openjdk" => :test
  
    def install
      on_macos do
        system "make", "FAT_BINARY=true"
      end
  #     on_linux do
  #       system "make", "CC=/usr/local/musl/bin/musl-gcc"
  #     end
  
      bin.install Dir["build/bin/*"]
      lib.install Dir["build/lib/*"]
      libexec.install Dir["build/jar/*"]
    end
  
    test do
      assert_match "Async-profiler #{version}", shell_output("#{bin}/asprof --version")
  
      (testpath/"Main.java").write <<~JAVA
        public class Main {
          public static void main(String[] args) throws Exception {
            Thread.sleep(10_000);
          }
        }
      JAVA
  
      pid = spawn Formula["openjdk"].bin/"java", testpath/"Main.java"
      system bin/"asprof", "-d", "2", "-f", testpath/"test-profile-via-attach.html", "jps"
      assert_predicate testpath/"test-profile-via-attach.html", :exist?
  
      system Formula["openjdk"].bin/"java", "-agentpath:#{lib}/libasyncProfiler.dylib=start,event=cpu,lock=10ms,file=test-profile-via-lib.jfr", testpath/"Main.java"
      assert_predicate testpath/"test-profile-via-lib.jfr", :exist?
    ensure
      Process.kill("TERM", pid)
    end
  end
  
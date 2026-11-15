class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java using AsyncGetCallTrace + perf_events"
  homepage "https://github.com/async-profiler/async-profiler"
  url "https://github.com/async-profiler/async-profiler/archive/refs/tags/v4.6.tar.gz"
  sha256 "f1c8d0a1afac4330d1b4d1bc911874516bc06109d1f5c87d2ff699d9ef4b39cb"
  license "Apache-2.0"
  head "https://github.com/async-profiler/async-profiler.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7c23638889a7f7adaf509a9f97cc9db2247596d06088f498ff51aaf1d5395dea"
    sha256 cellar: :any, arm64_tahoe:       "c5339c2ba41d116da1ff5947e3a02d472ac9883c938d65741cfb15b9d8661770"
    sha256 cellar: :any, arm64_sequoia:     "8db797e09b9abb6fc5387f6676cd476397f64c3b5c56f7966ac3a077a8323c7d"
    sha256 cellar: :any, arm64_linux:       "07d282fe7938f23dafefeba388a5f168f175f7010dd20712bb064e09e7b4ab2e"
    sha256 cellar: :any, x86_64_linux:      "d67d6f9a28314ac1e9509615abd607fecf11a06f0bd202f4faca38b1cb24ab55"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => [:build, :test]

  deny_network_access!

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
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")

    # Verify version output
    output = shell_output("#{bin}/asprof --version")

    assert_match version.to_s, output

    # Create a simple Java program that sleeps for testing
    (testpath/"Main.java").write <<~JAVA
      public class Main {
        public static void main(String[] args) throws Exception {
          Thread.sleep(Integer.parseInt(args[0]));
        }
      }
    JAVA

    # The profiler can begin started as a JVMTI agent
    agent_lib = shared_library("libasyncProfiler")
    system formula_opt_bin("openjdk")/"java",
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

class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java using AsyncGetCallTrace + perf_events"
  homepage "https://github.com/async-profiler/async-profiler"
  url "https://github.com/async-profiler/async-profiler/archive/refs/tags/v4.5.tar.gz"
  sha256 "807b83aefc86fcb067395d526684f3ea127919d611fe3bde1647938af7522869"
  license "Apache-2.0"
  head "https://github.com/async-profiler/async-profiler.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7a6ef5d802f552069cae0f1bf996d2531a483e0b1f6ff1eecde005c5a80a43e3"
    sha256 cellar: :any, arm64_sequoia: "0fe8ba37688e5010871840251b95b9ce59fff80f482865a329a603cb655fa4c7"
    sha256 cellar: :any, arm64_sonoma:  "7eb94695c8ef4e80ba95292113ac2f95558e026a8f3b50ebfe44d6ad59a6a4cb"
    sha256 cellar: :any, sonoma:        "9f374919114caf5d1d80318db54edea72c0aa81b5c0551ed54651d2fa0c0cc19"
    sha256 cellar: :any, arm64_linux:   "ebca17f909478321a9d7185b97637af9cd72c30633bcc3fdfb5d02449b179cb0"
    sha256 cellar: :any, x86_64_linux:  "8e5e7eb07a23f364a054285bf0eb1b77d85023e7af378c6b8ab426503593e9f4"
  end

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

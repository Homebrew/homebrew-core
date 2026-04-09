class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java using AsyncGetCallTrace + perf_events"
  homepage "https://github.com/async-profiler/async-profiler"
  url "https://github.com/async-profiler/async-profiler/archive/refs/tags/v4.3.tar.gz"
  sha256 "50f65033df0b999d0ae80c82d09827b595ad06051406ff7ec322fd1a40c1d328"
  license "Apache-2.0"
  head "https://github.com/async-profiler/async-profiler.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a22cc696b639d326786fb71cd8a1dc121aba26962aaa87e5ec68057795edccc2"
    sha256 cellar: :any,                 arm64_sequoia: "c339e4e5c3463a45ecdb4a93633854559e40ff128ba3eaa7dae2665935d8285f"
    sha256 cellar: :any,                 arm64_sonoma:  "976d7a9057d97a490aaa95ea0e908f8066ce0629114cdc64f25ba4df7e7495b6"
    sha256 cellar: :any,                 sonoma:        "eaa11bd51896193995a0902f7bc5ad698154169cc01920793d1270f95bce7fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb5b1bb4f00674a12985f31b5aa79f9fd9a33f62b96a640c3b57bfdcfe877ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2b7eb1b4d1c8704e028f8e4ea609de3b94c84348da76d65d765b525a4904f93"
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
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

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

class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java using AsyncGetCallTrace + perf_events"
  homepage "https://github.com/async-profiler/async-profiler"
  url "https://github.com/async-profiler/async-profiler/archive/refs/tags/v4.4.tar.gz"
  sha256 "888483f6fc482b32dfc76dc9ecb254dc954c1e5c893de325a895b41e2f9bbbf6"
  license "Apache-2.0"
  head "https://github.com/async-profiler/async-profiler.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56d2adc45828051bcdd6fd6a2549fff196916dc6a2b548da3509ac69eb627244"
    sha256 cellar: :any,                 arm64_sequoia: "a39fdee58eb4114f3682dd4f4cff62c9dbda2331c3dbabb99c30ffe39fafb52d"
    sha256 cellar: :any,                 arm64_sonoma:  "4ea1630c71f5b51a727c9f08f202cc4afe8fc2d86cfabbd0aadb93df28ff4848"
    sha256 cellar: :any,                 sonoma:        "3d69c4c9ab10e2fa4b6ad557c6eaa5ac464964af8eafc117f17e94cc78103acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf8739df298c90ac9a73905323fa493bd19b7ddab6e24b9bafc31e854eed54e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f512a5fd52cc4120f2036d1a0254f732e9ea12e0652cab4895dee7c3dcd40c2"
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

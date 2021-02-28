class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.16.0.tar.gz"
  sha256 "d52d705f159595c12341c54c34a18f8bb55bd55c3f4cc2493c0f9cf37405b109"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4c90b8a7f56a51076160771080c7f6616c1fa4480c33ffd49d6454a043f506f4"
    sha256 cellar: :any, big_sur:       "808ea1ab203cd442649754abdbf872a7d362d23e0146e6decb5922c6004c8622"
    sha256 cellar: :any, catalina:      "6c093d73221961f2ee0a588f4992c6fe587cdcb0c3a6a3266df0218ec1f44fca"
    sha256 cellar: :any, mojave:        "0f2f4d88aeb190bb6aa9169e4d7918de639cccad263cd2da93468bd0c6194136"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "vips"

  # fix github.com/bugsnag/panicwrap@v1.2.2/monitor.go:56:8: undefined: dup2
  patch :DATA

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 10

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/fit/100/100/no/0/plain/local:///test.jpg@png"
    assert_equal 0, $CHILD_STATUS
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "1 x 1", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

__END__
diff --git a/go.mod b/go.mod
index f8042c9..fbab8e9 100644
--- a/go.mod
+++ b/go.mod
@@ -33,3 +33,5 @@ require (
 replace git.apache.org/thrift.git => github.com/apache/thrift v0.0.0-20180902110319-2566ecd5d999

 replace github.com/shirou/gopsutil => github.com/shirou/gopsutil v2.20.9+incompatible
+
+replace github.com/bugsnag/panicwrap => github.com/bugsnag/panicwrap v1.3.1
diff --git a/go.sum b/go.sum
index 4647f94..461b703 100644
--- a/go.sum
+++ b/go.sum
@@ -118,8 +118,8 @@ github.com/bmizerany/assert v0.0.0-20160611221934-b7ed37b82869 h1:DDGfHa7BWjL4Yn
 github.com/bmizerany/assert v0.0.0-20160611221934-b7ed37b82869/go.mod h1:Ekp36dRnpXw/yCqJaO+ZrUyxD+3VXMFFr56k5XYrpB4=
 github.com/bugsnag/bugsnag-go v1.8.0 h1:XnZesafFtcqPryuLUNsWlaTWhdaOcDT66tiorzWVdu4=
 github.com/bugsnag/bugsnag-go v1.8.0/go.mod h1:2oa8nejYd4cQ/b0hMIopN0lCRxU0bueqREvZLWFrtK8=
-github.com/bugsnag/panicwrap v1.2.2 h1:2VFfhwhgp270P+wDa/JBt5x7qSm3zOCYoomGX93N8O0=
-github.com/bugsnag/panicwrap v1.2.2/go.mod h1:D/8v3kj0zr8ZAKg1AQ6crr+5VwKN5eIywRkfhyM/+dE=
+github.com/bugsnag/panicwrap v1.3.1 h1:pmuhHlhbUV4OOrGDvoiMjHSZzwRcL+I9cIzYKiW4lII=
+github.com/bugsnag/panicwrap v1.3.1/go.mod h1:D/8v3kj0zr8ZAKg1AQ6crr+5VwKN5eIywRkfhyM/+dE=
 github.com/casbin/casbin/v2 v2.1.2/go.mod h1:YcPU1XXisHhLzuxH9coDNf2FbKpjGlbCg3n9yuLkIJQ=
 github.com/cenkalti/backoff v2.2.1+incompatible/go.mod h1:90ReRw6GdpyfrHakVjL/QHaoyV4aDUVVkXQJJJ3NXXM=
 github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod h1:f6KPmirojxKA12rnyqOA5BBL4O983OfeGPqjHWSTneU=

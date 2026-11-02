class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.21.tar.gz"
  sha256 "0a6435d02ca43d3acabece4ee840716c3d5314c740877a2689492ad260778f03"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b738d60c0bd785285953d816881a47553fe3d2b841a8cf1b0373854d9a4ad60a"
    sha256 cellar: :any, arm64_tahoe:       "2808dcd92a897b70f1810a355fb185b8443e4a0755544cc62ec17630dcf3e5f4"
    sha256 cellar: :any, arm64_sequoia:     "c2786046cbc6bc0ad7197e42b8fc96df71e9133ed3b4fa73bf8d6b9e05a66080"
    sha256 cellar: :any, arm64_linux:       "34d898f026cd33c969bbd0ccbf35472abf6ea4c598003c0d76d6d2018e560483"
    sha256 cellar: :any, x86_64_linux:      "f25707d8b064642cc90e8683231981017a9c10fbc1e94e1d76e41b6893ca66c5"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args, "./cli"
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20

    output = testpath/"test-converted.png"
    url = "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"

    system "curl", "-s", "-o", output, url
    assert_path_exists output

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

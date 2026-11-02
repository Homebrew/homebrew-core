class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.21.tar.gz"
  sha256 "0a6435d02ca43d3acabece4ee840716c3d5314c740877a2689492ad260778f03"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "36e87b0f7614bb5da939f8af347cb8d83d5cbcc02838a8cd7c97c7a3ffd4cf47"
    sha256 cellar: :any, arm64_tahoe:       "f17b1778a15a3d04ff39bcfd936bc4aa58dbf7853e301093a6771eb2ae896f63"
    sha256 cellar: :any, arm64_sequoia:     "e6789740270a9ecf650cc7e9e45adab084f8168bbab1d461bb99e3bd5ec59821"
    sha256 cellar: :any, arm64_linux:       "5dbdf368d7f96bbad9cc32c0b96545f4cce0da8f9c62b984bdf00a3443f54698"
    sha256 cellar: :any, x86_64_linux:      "4646af5358c0b01aff12d5cd7c136c42b5c028c8363ab31863073dbf8f631da8"
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

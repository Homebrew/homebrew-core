class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.22.tar.gz"
  sha256 "c77831181c53913f512821fd11fca693e1c3db260802c789121439ce1ec43313"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0c1699dc2461e42f3b6166ca36c7523360c0c637502349fc6fe76363d107d12b"
    sha256 cellar: :any, arm64_tahoe:       "4d4fa5e8671fae89543cf3e1c71994cfbb53db1425c5f983639a943fd3b4b6a9"
    sha256 cellar: :any, arm64_sequoia:     "543aca782e2e9b0b6662c28b34440488de6acca733c3ed23d83646256fb4e5b6"
    sha256 cellar: :any, arm64_linux:       "f8b727a4ec8c6ce6d77326a34b3be37284e223f0d377a9dc5c85077375f05bf6"
    sha256 cellar: :any, x86_64_linux:      "0bde0d2fbde45d4bb05153cb7b9a8c9cc974008626e4802507bdec0d1888d5d4"
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

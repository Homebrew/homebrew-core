class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v3.10.0.tar.gz"
  sha256 "73ada6a257f57b70c50904945a707677aeb5b4da8c70fa294308563630d58c9c"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56ce199c083a77bf813242946ddae8ef0344fddecd0df6d429cc3c34dd9210df"
    sha256 cellar: :any,                 arm64_big_sur:  "5acffa368a4340e763d0e66d6a97d66cce91f72769c858a47baca2c164def8fc"
    sha256 cellar: :any,                 monterey:       "5e4ad926992134d275030fb11cd09e15bab101b456b29ae2095c753abdda4f66"
    sha256 cellar: :any,                 big_sur:        "d7951cc51d060338d293207e60a0c88cdf54162ea6b20f135c29a2f1b86a7b9e"
    sha256 cellar: :any,                 catalina:       "f6a51a4bbc92d3fd22d07d14cdcbced2023722852f0ae03644a3224fea4f1809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60cabc7cb46034b4e2b127334561b244db17a227038176d584cfbe5aa2ffa51"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "vips"

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
           "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

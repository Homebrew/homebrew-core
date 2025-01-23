class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.27.1.tar.gz"
  sha256 "ab09340fbb2e3928d458c3d26bf6af28010e57bded98d04475fa9922d43f6646"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d2c0282b96bf64d1a96246cf42dc6e50e04d348b07f3faf2509c55dcd170076"
    sha256 cellar: :any,                 arm64_sonoma:  "f0bdf0ae96565aa02c7eb38d2cf53685d82777366b4a796ab05842fb384cf3aa"
    sha256 cellar: :any,                 arm64_ventura: "2ef9b7d1239dd0da9b9ca43c4a1f1e82b39ceb73f8702962508e4ebb7a2abc23"
    sha256 cellar: :any,                 sonoma:        "f7ff13716c22f7dd7e5dc7035d5312eb13283a5c08d1ad993cd4d4fedb1f0b5d"
    sha256 cellar: :any,                 ventura:       "3f01f079c4290c5dcce1cd58b9c1ecca30dc8ea74a22c9ba2daca937e75defc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec8a6eed15af825dc8a201e96ae4ec8aa9c242777ba135e7e05e59f4ddddb2a6"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20
    sleep 40 if OS.mac? && Hardware::CPU.intel?

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

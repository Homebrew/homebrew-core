class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.16.0",
      revision: "8fb3cb86082b17144a80402f5367ae65f06083bd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "537b7a21bbf0d1afb2287e7417f2a0a044207be845ef91778d40c0e1a2898a9d" => :catalina
    sha256 "80eaea1fece13477a5f5c57412bafabab64e13edab9bf261147fead8b08e8f6d" => :mojave
    sha256 "a66395e2f2aa616f930356904b866b0a0c28b6cb57ed3c151a2e257a4758b276" => :high_sierra
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build

  def install
    args = %w[
      --curses=no
      --show_task_finish
      --verbose_failures
      --action_env=PATH=/usr/local/bin:/opt/local/bin:/usr/bin:/bin
      --test_output=all
    ]
    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static"
    bin.install "bazel-bin/source/exe/envoy-static" => "envoy"
    pkgshare.install "configs", "examples"
  end

  test do
    port = free_port

    cp pkgshare/"configs/google_com_proxy.v2.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end

    fork do
      exec bin/"envoy", "-c", "envoy.yaml"
    end
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  end
end

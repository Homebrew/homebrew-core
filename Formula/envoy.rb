class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.16.2",
      revision: "e98e41a8e168af7acae8079fc0cd68155f699aa3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "53c47a2d719a6382a6ba8810b451e350f9c5ad3ffed1b6e5a0732eab8808cf5b" => :big_sur
    sha256 "fe4cf7943fd603ceb507a55c085c55124c10ea0b8bcd3c4c6ceac145b47cadb4" => :catalina
    sha256 "9872a1ec13f0aee427ac9715a6bc5ccf9d4f505c3aca6e94f18ae28f9f673a1a" => :mojave
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

class EnvoyAT118 < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.18.4",
      revision: "bef18019d8fc33a4ed6aca3679aff2100241ac5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5f3ba6a5d7693915bc43816a58e443df7e8eb045548d6b4a72553c9ece062668"
    sha256 cellar: :any_skip_relocation, catalina: "8c5378d2ad7d927aabdaab0c747e1b284b5e122aab4b08096c59c13d43c773c6"
  end

  keg_only :versioned_formula
  # https://github.com/envoyproxy/envoy/blob/main/RELEASES.md#release-schedule
  deprecate! date: "2022-04-15", because: :unsupported

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on macos: :catalina

  # Work around xcode 12 incompatibility until envoyproxy/envoy#17393
  patch do
    url "https://github.com/envoyproxy/envoy/commit/3b49166dc0841b045799e2c37bdf1ca9de98d5b1.patch?full_index=1"
    sha256 "e65fe24a29795606ea40aaa675c68751687e72911b737201e9714613b62b0f02"
  end

  def install
    args = %W[
      -c
      opt
      --curses=no
      --show_task_finish
      --verbose_failures
      --action_env=PATH=#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin
    ]
    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static"
    bin.install "bazel-bin/source/exe/envoy-static" => "envoy"
    pkgshare.install "configs", "examples"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
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

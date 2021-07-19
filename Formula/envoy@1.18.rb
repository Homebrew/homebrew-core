class EnvoyAT118 < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.18.3",
      revision: "98c1c9e9a40804b93b074badad1cdf284b47d58b"
  license "Apache-2.0"

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

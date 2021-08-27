class EnvoyAT118 < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.18.4",
      revision: "bef18019d8fc33a4ed6aca3679aff2100241ac5e"
  license "Apache-2.0"

  # Apple M1/arm64 is pending envoyproxy/envoy#16482
  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3536e288183abeb9f36505065c889bc376ca3b3b3e526f8850a33d5b9a0399d5"
    sha256 cellar: :any_skip_relocation, catalina: "2af03e6c0a7f978f1f87ffdb84861c9e75995ff783356f14e088c07bb8bbb03f"
  end

  keg_only :versioned_formula
  # https://github.com/envoyproxy/envoy/blob/main/RELEASES.md#release-schedule
  deprecate! date: "2022-04-15", because: :unsupported

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
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

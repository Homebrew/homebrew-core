class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.17.1",
      revision: "d6a4496e712d7a2335b26e2f76210d5904002c26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b02a569c32ab1e14d2004827df257a809482b3350a6d893c4896961b2b4da474"
    sha256 cellar: :any_skip_relocation, catalina: "2fae1ff1f55e21b1d9f686e5f84888e53c878308885dc610bfea80e0fd15b465"
    sha256 cellar: :any_skip_relocation, mojave:   "1752e6db90513c6828f7fbf349bcef42bf227cdd6ea1b5acb04e1b92788f463c"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build

  # Fix MarkupSafe hash error.
  # Remove with the next release (if backported).
  patch do
    url "https://github.com/envoyproxy/envoy/commit/b1caeb356f9b36be86fe1e0c161f8813b0654dfc.patch?full_index=1"
    sha256 "748a3664a3d89e91983fa3ad33ed6307649bcbd624335cc4d4b18ca299d9b8f2"
  end

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

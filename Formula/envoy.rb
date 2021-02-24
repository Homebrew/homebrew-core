class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.17.0",
      revision: "5c801b25cae04f06bf48248c90e87d623d7a6283"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "153d9b2bbda922100c14055e0fcc29522f4fe5edc88c1e0b282cd3ed3f6caea7"
    sha256 cellar: :any_skip_relocation, catalina: "b03ea0b99cac58d48d35c82b224946a4386d421814e9518648b3c4f336dfeee8"
    sha256 cellar: :any_skip_relocation, mojave:   "75577ea666c638d0d7e63250b73e2a78f6d22b5a2b3a1bc8a460528f0713721c"
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
    url "https://github.com/envoyproxy/envoy/commit/0d5b470097d5e3645759e43414db8a7104aafb2e.patch?full_index=1"
    sha256 "47c350ef1a27cb23dfe69f19427d1db582b7ff7268d966bd65094054f453f960"
  end
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

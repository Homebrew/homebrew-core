class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.18.3",
      revision: "98c1c9e9a40804b93b074badad1cdf284b47d58b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6102aca3db84b37f631cefbc4750fe4d4c69cdfbb9c6c010c0ceaffea5056f6e"
    sha256 cellar: :any_skip_relocation, catalina: "79d7320da0300b598b5edefe3d6c9bb14d8cb8b08ca2cf838923e7a682f44409"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build

  on_macos do
    depends_on "gcc" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause "error: no viable overloaded operator[] for type '::google::protobuf::Map<std::string, std::string>'"
  end

  def install
    on_macos do
      if DevelopmentTools.clang_build_version <= 1100
        gcc = Formula["gcc"]
        ENV["CC"] = gcc.opt_bin/"gcc-#{gcc.any_installed_version.major}"
        ENV["CXX"] = gcc.opt_bin/"g++-#{gcc.any_installed_version.major}"
      end
    end

    args = %W[
      --curses=no
      --show_task_finish
      --verbose_failures
      --action_env=PATH=#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin
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

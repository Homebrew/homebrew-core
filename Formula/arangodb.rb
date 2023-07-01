class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.11.1.tar.bz2"
  sha256 "e13367c11c654a0c059fce52835ecef19f0c4cc58d836cf405149a4c1b8a7158"
  license "Apache-2.0"
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  livecheck do
    url "https://www.arangodb.com/download-major/source/"
    regex(/href=.*?ArangoDB[._-]v?(\d+(?:\.\d+)+)(-\d+)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "53afa49b9a2e4848ca33ea0933a521b50a43b36849d2c5fea08443034dd8d778"
    sha256 arm64_monterey: "7cd65f1950e1f3a469a0978fec85f76ff2de404b17abca40d55945806e7de59d"
    sha256 arm64_big_sur:  "c9249d113644c8c19d4fe4a94631a9dcc3c41d4130ec7d1aa16caf8b25574e33"
    sha256 ventura:        "5f4b3a814c2a756c42c711b272c36aa8a651dd6bc2b4adbfae5a568962b582eb"
    sha256 monterey:       "a2a85d8865eaee4b53a58de0698fad4ef52639dbad12527f212390a865b1e034"
    sha256 big_sur:        "1e869c623de4995794d0da8c759300cb6df35d5f12160d4aece1bbe31dfcf56d"
    sha256 x86_64_linux:   "7c80cd9f061e99a34be19691bb039015a10c231892c3e13e6af7e0d2377c0fa6"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on macos: :mojave
  depends_on "openssl@3"

  on_macos do
    # Fails to build with LLVM 16:
    # /tmp/arangodb-20230630-89543-1vkojor/ArangoDB-3.11.1/lib/Inspection/include/Inspection/Access.h:52:3:
    # error: static assertion failed due to requirement 'detail::IsInspectable()'
    #
    # Upstream had decided to only guarantee support for specific compiler versions,
    # which is LLVM 14 in 3.11.1 (https://github.com/arangodb/arangodb/blob/devel/VERSIONS).
    # We pick the latest LLVM version that we are able to successfully compile with.
    depends_on "llvm@15" => :build
  end

  fails_with :clang do
    cause <<-EOS
      .../arangod/IResearch/AqlHelper.h:563:40: error: no matching constructor
      for initialization of 'std::string_view' (aka 'basic_string_view<char>')
              std::forward<Visitor>(visitor)(std::string_view{prev, begin});
                                             ^               ~~~~~~~~~~~~~
    EOS
  end

  fails_with :gcc do
    version "10"
    cause "requires std::atomic<T>::wait support"
  end

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
        tag:      "0.15.8",
        revision: "99ac5bed2bb07def49bb64f837485b993337b8ef"
  end

  # Workaround for compiler bug in GCC 11.3 used by Ubuntu 22.04.
  # TODO: Try to remove if Ubuntu updates to GCC 11.4.
  # Issue ref: https://github.com/arangodb/arangodb/issues/17454
  #
  # TODO: Initially commented out to try without patch
  #
  # patch do
  #   on_linux do
  #     url "https://github.com/iresearch-toolkit/iresearch/commit/6c4e2f00bb672fe022481daeb60b33afbdbfd729.patch?full_index=1"
  #     sha256 "084f2c9c379f004e1f3cc662398b0082d0028f2d9f28f2e7dce4871389f8286a"
  #     directory "3rdParty/iresearch"
  #   end
  # end

  def install
    if OS.mac?
      ENV["CC"] = Formula["llvm@15"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm@15"].opt_bin/"clang++"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      # Fix building bundled boost with newer LLVM by avoiding removed `std::unary_function`.
      # .../boost/1.78.0/boost/container_hash/hash.hpp:132:33: error: no template named
      # 'unary_function' in namespace 'std'; did you mean '__unary_function'?
      #
      # ENV.append "CXXFLAGS", "-DBOOST_NO_CXX98_FUNCTION_BASE=1"
    end

    resource("starter").stage do
      ldflags = %W[
        -s -w
        -X main.projectVersion=#{resource("starter").version}
        -X main.projectBuild=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    args = %W[
      -DHOMEBREW=ON
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_GOOGLE_TESTS=OFF
      -DUSE_JEMALLOC=OFF
      -DUSE_MAINTAINER_MODE=OFF
    ]
    # The default/minimum x86_64 target is SandyBridge which is too new for Homebrew bottles.
    # So we use an unsupported value and let Homebrew handle optimization via `-march`.
    args << "-DTARGET_ARCHITECTURE=none" if Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS
  end

  service do
    run opt_sbin/"arangod"
    keep_alive true
  end

  test do
    require "pty"

    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp

    ohai "#{bin}/arangodb --starter.instance-up-timeout 1m --starter.mode single"
    PTY.spawn("#{bin}/arangodb", "--starter.instance-up-timeout", "1m",
              "--starter.mode", "single", "--starter.disable-ipv6",
              "--server.arangod", "#{sbin}/arangod",
              "--server.js-dir", "#{share}/arangodb3/js") do |r, _, pid|
      loop do
        available = r.wait_readable(60)
        refute_equal available, nil

        line = r.readline.strip
        ohai line

        break if line.include?("Your single server can now be accessed")
      end
    ensure
      Process.kill "SIGINT", pid
      ohai "shutting down #{pid}"
    end
  end
end

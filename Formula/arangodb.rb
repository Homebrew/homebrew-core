class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.10.0.tar.bz2"
  sha256 "48b36216541f9da8ca86ce304a3ea96964da53a324c94c9a229552af70949726"
  license "Apache-2.0"
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  livecheck do
    url "https://www.arangodb.com/download-major/source/"
    regex(/href=.*?ArangoDB[._-]v?(\d+(?:\.\d+)+)(-\d+)?\.t/i)
  end

  bottle do
    sha256 monterey:     "fa9cfb815626809db09fae96b14902750d52b32045c204be4d3dd47b2153591a"
    sha256 big_sur:      "2d89e2bb77096fec1cc03ddc38faffb3c783b151b8e901951bf3bb9598120282"
    sha256 catalina:     "2b6ef1ed9d1b984ffb10d813151eae4f9f7bfdf8a735496a3454026b51030e5b"
    sha256 x86_64_linux: "2b4b33bdaa222b35622a15cffc573769b7206851531eb5576de11af2cca29cdd"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python@3.10" => :build
  depends_on macos: :mojave
  depends_on "openssl@1.1"

  on_macos do
    depends_on "llvm" => :build
  end

  fails_with :clang do
    cause <<-EOS
      .../arangod/IResearch/AqlHelper.h:563:40: error: no matching constructor
      for initialization of 'std::string_view' (aka 'basic_string_view<char>')
              std::forward<Visitor>(visitor)(std::string_view{prev, begin});
                                             ^               ~~~~~~~~~~~~~
    EOS
  end

  # https://www.arangodb.com/docs/stable/installation-compiling-debian.html
  fails_with :gcc do
    version "8"
    cause "requires at least g++ 9.2 as compiler since v3.7"
  end

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
        tag:      "0.15.5",
        revision: "7832707bbf7d1ab76bb7f691828cfda2a7dc76cb"
  end

  def install
    if OS.mac?
      ENV.llvm_clang
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      # Fix building bundled boost with newer LLVM by avoiding removed `std::unary_function`.
      # .../boost/1.78.0/boost/container_hash/hash.hpp:132:33: error: no template named
      # 'unary_function' in namespace 'std'; did you mean '__unary_function'?
      ENV.append "CXXFLAGS", "-DBOOST_NO_CXX98_FUNCTION_BASE=1"
    end

    resource("starter").stage do
      ldflags = %W[
        -s -w
        -X main.projectVersion=#{resource("starter").version}
        -X main.projectBuild=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    arch = if Hardware::CPU.arm?
      "neon"
    elsif !build.bottle?
      # Allow local source builds to optimize for host hardware.
      # We don't set this on ARM since auto-detection isn't supported.
      "auto"
    elsif Hardware.oldest_cpu == :core2
      # Closest options to Homebrew's core2 are `core`, `merom`, and `penryn`.
      # `core` only enables up to SSE3 so we use `merom` which enables up to SSSE3.
      # As -march=merom doesn't exist in GCC/LLVM, build will fall back to -march=core2
      "merom"
    else
      Hardware.oldest_cpu
    end

    args = std_cmake_args + %W[
      -DHOMEBREW=ON
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DTARGET_ARCHITECTURE=#{arch}
      -DUSE_GOOGLE_TESTS=OFF
      -DUSE_JEMALLOC=OFF
      -DUSE_MAINTAINER_MODE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
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

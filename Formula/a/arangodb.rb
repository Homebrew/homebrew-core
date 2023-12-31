class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.10.4.tar.bz2"
  sha256 "bc9cfaac5747995a6185d2cfea452b9fea8461bf91d2996dd75af75eef3cfddd"
  license "Apache-2.0"
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  bottle do
    sha256 arm64_ventura:  "53afa49b9a2e4848ca33ea0933a521b50a43b36849d2c5fea08443034dd8d778"
    sha256 arm64_monterey: "7cd65f1950e1f3a469a0978fec85f76ff2de404b17abca40d55945806e7de59d"
    sha256 arm64_big_sur:  "c9249d113644c8c19d4fe4a94631a9dcc3c41d4130ec7d1aa16caf8b25574e33"
    sha256 ventura:        "5f4b3a814c2a756c42c711b272c36aa8a651dd6bc2b4adbfae5a568962b582eb"
    sha256 monterey:       "a2a85d8865eaee4b53a58de0698fad4ef52639dbad12527f212390a865b1e034"
    sha256 big_sur:        "1e869c623de4995794d0da8c759300cb6df35d5f12160d4aece1bbe31dfcf56d"
    sha256 x86_64_linux:   "7c80cd9f061e99a34be19691bb039015a10c231892c3e13e6af7e0d2377c0fa6"
  end

  # Vendors deps, has a low download count, build always breaks
  # https://github.com/Homebrew/homebrew-core/pull/135487#issuecomment-1616018628
  deprecate! date: "2023-07-05", because: :does_not_build

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on macos: :mojave
  depends_on "openssl@1.1"

  on_macos do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "gcc@10" => :build
  end

  fails_with :clang do
    cause <<-EOS
      .../arangod/IResearch/AqlHelper.h:563:40: error: no matching constructor
      for initialization of 'std::string_view' (aka 'basic_string_view<char>')
              std::forward<Visitor>(visitor)(std::string_view{prev, begin});
                                             ^               ~~~~~~~~~~~~~
    EOS
  end

  # https://github.com/arangodb/arangodb/issues/17454
  # https://github.com/arangodb/arangodb/issues/17454
  fails_with gcc: "11"

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
        tag:      "0.15.7",
        revision: "0cd043932e6c6f2bd9dc0391ea0313c304b3ca9d"
  end

  def install
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

    cmake_args = std_cmake_args + %W[
      -DHOMEBREW=ON
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DTARGET_ARCHITECTURE=#{arch}
      -DUSE_GOOGLE_TESTS=OFF
      -DUSE_JEMALLOC=OFF
      -DUSE_MAINTAINER_MODE=OFF
    ]

    if OS.mac?
      ENV.llvm_clang

      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}"

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

    system "cmake", "-S", ".", "-B", "build", *cmake_args
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

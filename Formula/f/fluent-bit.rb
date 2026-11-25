class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "c0673382fdbf220a35216dbe70521333e0d1f1da9acc70a76dc3f765b4ab1d08"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "b15e2ddcb4a54d5bb0eb7ed1b70d3441545ad7b72c60f8b1c325da4d3bf089e5"
    sha256 cellar: :any, arm64_golden_gate: "0d9907580395e9a617d9512aa54768c1196901d19be8662163a07b14770e0202"
    sha256 cellar: :any, arm64_tahoe:       "6853085115371188265833d1a29703df3aa8a16ea67f728d1725d385f688c3d7"
    sha256 cellar: :any, arm64_sequoia:     "4ec2586cd208b2d1e10318e1657e4b2716c01c93761936ad7bbdb22989b8b7f3"
    sha256 cellar: :any, arm64_linux:       "082dc4a9a9ca4d9eda90d9e13ad2d6c34393326af0bd6e4e160fc06f1a892737"
    sha256 cellar: :any, x86_64_linux:      "fb75adcfc85f2cd7031e68641f4e81fb3ecbf1e8b65888256402d47d962574cc"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end

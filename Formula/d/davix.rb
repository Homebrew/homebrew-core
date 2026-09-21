class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_9_0/davix-0.9.0.tar.gz"
  sha256 "cf68461550fcd8fd88320658a42c55c7e7f6653e2be1461dfa95013adc56cced"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  livecheck do
    url :stable
    regex(/^R[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "00877d9f490a442b161b63dd2539dcf425d4829434c8fd680eab4218b4e2def1"
    sha256 cellar: :any, arm64_tahoe:       "768bab554a4616b78d60f68b8b59c54ac33ae321a0446c3b2d281ea553c98a5e"
    sha256 cellar: :any, arm64_sequoia:     "7b056970935b827997ff53f981bef6c09a7b565059713522eb70cb319d05ce4a"
    sha256 cellar: :any, arm64_sonoma:      "7c82e7763b256d8a543569b8e87afb45b03061a2ec7f8e86f7222cb192864904"
    sha256 cellar: :any, sonoma:            "b7f07ce68e60b17481a927d85c528d5b19d53d648fad7a6ead5583f2e1417a4d"
    sha256 cellar: :any, arm64_linux:       "607a56eadd9d0b1c877ac42198065075ce30b46a2836e3af87a96f0bcbedb094"
    sha256 cellar: :any, x86_64_linux:      "fde5fe3e3cd84a4e04df4150b9dcf46c8464138c2e50469e03dbed3abbd36b2c"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    # Remove `-DCMAKE_POLICY_VERSION_MINIMUM=3.5` once fixed upstream
    # Issue ref: https://github.com/cern-fts/davix/issues/139
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIB_SUFFIX=
      -DBENCH_TESTS=FALSE
      -DDAVIX_TESTS=FALSE
      -DEMBEDDED_LIBCURL=FALSE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"davix-get", "https://brew.sh"
  end
end

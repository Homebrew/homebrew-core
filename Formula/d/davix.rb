class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_9_0/davix-0.9.0.tar.gz"
  sha256 "cf68461550fcd8fd88320658a42c55c7e7f6653e2be1461dfa95013adc56cced"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  livecheck do
    url :stable
    regex(/^R[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d4d7f8c10dbc10d91414afc02a67cc8d6e26accce634872cc51af610f58ca8d4"
    sha256 cellar: :any, arm64_tahoe:       "7b741a287cb9064e54af4f07d8c6a6377733b1bb2222fc0a4e1160b4a76d73f7"
    sha256 cellar: :any, arm64_sequoia:     "8e75f4bbfa7dc97c3f389dcc417000fa4f1bf55a282e4825ffc4817f9615dc9d"
    sha256 cellar: :any, arm64_linux:       "f547ec51dcb73fe92bb17f5b3bd87a5fb8830059885f2313f9e554853a39d4d6"
    sha256 cellar: :any, x86_64_linux:      "b138417ed53c63ac93f20c822309d482ad4d584da210cb45228f9277c5d02f41"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  # Apply open PR from Fedora to support OpenSSL 4
  patch do
    url "https://github.com/cern-fts/davix/commit/5223f92a8472489acb427552317b160facccec2b.patch?full_index=1"
    sha256 "77a143f47564cb2f8020d4bffe2754593e160512a52b6240f76ce5acb981a956"
    type :unofficial
    resolves "https://github.com/cern-fts/davix/pull/151"
  end

  allow_network_access! :test

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

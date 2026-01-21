class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_10/davix-0.8.10.tar.gz"
  sha256 "66aa9adadee6ff2bae14caba731597ba7a7cd158763d9d80a9cfe395afc17403"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "147668e36df19a8719d55dbb89b1e3e2cdd0d8c024e945986ff606182570db6e"
    sha256 cellar: :any,                 arm64_sequoia: "8af6cc245e2a0e7b318bca8641aef15155c836c36d308eb872b139c7e338e90c"
    sha256 cellar: :any,                 arm64_sonoma:  "02c4ea3debe63de32221f93acc59efbd82e86c6615e52a91b97fbbf27eb6c29a"
    sha256 cellar: :any,                 sonoma:        "ca1f0617f83aa057c573860e846f9805f789b8ddbfa6bbcc4d5686b11b534406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90ba00d5d1122350f59985e06eee426689bf071bfb4afbfc1b1fcf039d2e3d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8097034116f7ade56b9aa9206c51d823ddb1b687dd7c7d38eaf300fa25caa17"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
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

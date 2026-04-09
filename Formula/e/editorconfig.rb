class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "ab9f897a90fb36cfc34e5b67221e55ab0e3119b3512de8e31029d376c6bab870"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e6eb22b09b7bdb92f13b0bbca313c416f3bc35afb49fdccd3e545b0c3e2a7495"
    sha256 cellar: :any,                 arm64_sequoia: "3d105c1564af5478682b0eecbae33493d4d7bce1fa27deefce379cd4a378b2a3"
    sha256 cellar: :any,                 arm64_sonoma:  "2219306829c82d5ae3871ea89775c8df2fe51ddf499b3552993f61a037a8d3cf"
    sha256 cellar: :any,                 sonoma:        "7fc20435dafc3a2bff98f8d124cea1c614217b645259e0b6f05fd910898fca70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7862f424b0deaf548cf321bea439d646a6572df6f71687f22ede45233c06f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a006709cbeafe7bc51cf287cf8a831c26df8b85ad65a7ffe35d360a0c741bef6"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"editorconfig", "--version"
  end
end

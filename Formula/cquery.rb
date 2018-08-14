class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180718",
                                                      :revision => "b523aa928acf8ffb3de6b22c79db7366a9672489"
  head "https://github.com/cquery-project/cquery.git"

  bottle do
    cellar :any
    sha256 "0f567e5d88299f28d489b666fca2cf320b91062fc053e0c2a8a1ad9e1bc76598" => :high_sierra
    sha256 "06bb25b1c91c76c894d3aebdc18b76591ab2ff1c5f8190c376b69e60d6c22787" => :sierra
    sha256 "9692d28682c009a9bec583ff20aa16ce5c790975375755a5a48a28ec3e3953c4" => :el_capitan
  end

  # error: 'shared_timed_mutex' is unavailable: introduced in macOS 10.12
  depends_on :macos => :sierra
  depends_on "cmake" => :build
  depends_on "llvm"

  needs :cxx14

  def install
    system "cmake", ".", "-DSYSTEM_CLANG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end

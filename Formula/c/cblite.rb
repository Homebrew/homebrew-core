class Cblite < Formula
  desc "Couchbase cblite command-line tool"
  homepage "https://github.com/couchbaselabs/couchbase-mobile-tools"
  url "https://github.com/couchbaselabs/couchbase-mobile-tools.git",
    tag:      "cblite-4.0.0EE",
    revision: "4de36110572a27b27e066a14392ad9283d7cfd28"
  version "4.0.0"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "cblite", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "cblite"
    bin.install "build/cblite"
  end

  test do
    system bin/"cblite", "--version"
  end
end

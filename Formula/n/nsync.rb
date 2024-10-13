class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https://github.com/google/nsync"
  url "https://github.com/google/nsync/archive/refs/tags/1.29.2.tar.gz"
  sha256 "1d63e967973733d2c97e841e3c05fac4d3fa299f01d14c86f2695594c7a4a2ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a3b52d87b9edb7d58f553ca104f219b34267f2a38f7b955b7f4e4583717ff8e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b882829292b6107a9a9071bedd749d1be71c1d3882b9d4bca871e8e78bb30bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17fc433b587e675763ec10ea6a3b8325b2c68341d76489c1b9e658761e153b5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e616712e71b17684f597c4c97c6d578dfd8a7b88187d335f3c719aa5c036bcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "73e3f9c25d2018fda3fd790c34d3babb957e4594491abc39bfb4bfa951be9c01"
    sha256 cellar: :any_skip_relocation, ventura:        "989d69d3a745db37dafdf27c20dc98999827e1e5e4fcd31f38d09f57812353ea"
    sha256 cellar: :any_skip_relocation, monterey:       "515ecebbb92213d35028eadbe7227e468a6a6524cbd50c9a0c3f8adf3c955851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3c65483e614249a252f27d6425ef5736ac8e8d28f517b4ac51cdcf0ed459c6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DNSYNC_ENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nsync.h>
      #include <stdio.h>

      int main() {
        nsync_mu mu;
        nsync_mu_init(&mu);
        nsync_mu_lock(&mu);
        nsync_mu_unlock(&mu);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lnsync", "-o", "test"
    system "./test"
  end
end

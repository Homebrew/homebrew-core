class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.10.0.tar.gz"
  sha256 "d588bca36357eda8bcafd5bc1f95df1afe613fdc70c80e426fc89eecb828fc3e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "43d555650695a9f254e85a217db625cf5fd912756e2980f221decc93491be1f5"
    sha256 cellar: :any,                 arm64_sonoma:  "ead7b40158e9d010fc8fe30801e1d97baf22db46cc57263bf0f37bbc91c91013"
    sha256 cellar: :any,                 arm64_ventura: "8f4508d5a3ec2b7f415e8311d4cd1b7d1b06fbf7d7aeb8db8ab02b4aeae2d8ef"
    sha256 cellar: :any,                 sonoma:        "298f5606fda37c02e4f9af95ff299e85556064b207620b0c16a1530df0c7c711"
    sha256 cellar: :any,                 ventura:       "fd27f45263b9823a6e6af417618bfd9b9f8bb8e532ea2365cf5212b3692ff502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b713e2bbfe3624a05ee971b3f37de6ba709362dd436cad66230e541ac016af"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  uses_from_macos "python" => :build, since: :catalina

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--disable-silent-rules", "--enable-shared", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end

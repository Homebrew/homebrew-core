class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.10.5.tar.gz"
  sha256 "a827dc8a02f4b6110bce66a56d8d97e4526a5128e2f36fa698fd2b1dfb1b9044"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c37900dc12a476a4d4c1d6027e28f5bcbd48dd0c13d0d5eef9130365db04f09"
    sha256 cellar: :any,                 arm64_sequoia: "a167b4c5b35c0e9226475349c2255eb13f471843a7bf2ab5749845ae0cb17b1a"
    sha256 cellar: :any,                 arm64_sonoma:  "5d6010ea63e22a52c3a57772b928c3db42258e03371d0fadcb342540d5e9f7eb"
    sha256 cellar: :any,                 sonoma:        "04c3c2f21bfd8c568c4de68c41c6110ec3bd96fbff44a22eec8c1b0cc1c41bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e2d5fa38a95abfaee1581de92d57b84b059364ad4d20908aaf53295467d6a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d837edceff2ce790992504d93fc7c46fbb1856ed6ccc747c78a5ccc8261be89"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  uses_from_macos "python" => :build

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

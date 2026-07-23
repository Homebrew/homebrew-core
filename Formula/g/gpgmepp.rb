class Gpgmepp < Formula
  desc "C++ bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgmepp/gpgmepp-2.1.0.tar.xz"
  sha256 "57f804468f0204504b172c6b139cb05124b4263be7ad514932c7c4c5062a16e2"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepp/"
    regex(/href=.*?gpgmepp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6f196a2bd021582ac5594962e57934662903a608aecebf4ac0e7ec98ce4e08c"
    sha256 cellar: :any,                 arm64_sequoia: "c95bcc1741df57ec84ce79cd9afd023c8ff0277e78f1c3847e2c7d4d614c6c6b"
    sha256 cellar: :any,                 arm64_sonoma:  "30e129696baf54d10fa6344323007c7226b541104f68121a3a2109ce0cf6252e"
    sha256 cellar: :any,                 sonoma:        "608c33cbd3a641560314ee7f77979440f0654394672d1407e264ce628ad3d514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "570a69d6e26e7857c93d7a8cf5f5bd912c11b0fabcca5472471422ee181782ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4ba880615a1632da127d6ef39b7ceddc2d9d665b290902cc2d21a446d707d5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gpgme"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp_r (pkgshare/"tests").children, testpath

    flags = shell_output("pkgconf --cflags --libs gpgmepp").chomp.split
    system ENV.cxx, "-std=c++17", "run-genrandom.cpp", "-o", "test",
                    "-I#{include}/gpgme++", *flags
    system "./test", "--number", "10"
  end
end

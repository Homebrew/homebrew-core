class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.3.tar.gz"
  sha256 "f9a9727af97441ae87ff9250e374b9fe3a32a3348b25cb50bd2b7de5ec7f5d82"
  license "ISC"
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f9f45763516449a9075be07735bf72855164b51ab549dbc07de6215bb163069a"
    sha256 arm64_big_sur:  "75177641b3a63332f5931f39ac61001f8e45aa8751cf3c37032889a9ef49ad3f"
    sha256 monterey:       "8ba71c5137d2f2170c901a55ee0e5854b997163f715c43d46c4b823b111005f3"
    sha256 big_sur:        "d270269663c58354047235b84a11360eb676e48e2bd1029077f58ef32d24b802"
    sha256 catalina:       "c09baa37e79632bad83a33cae733a06f22e5caa461c20c85749a345436e0ec2b"
    sha256 x86_64_linux:   "ef4df9e7c709ac5d717deb8b8f7b093c8936884e28039bd25ad494f56a5b1027"
  end

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
  depends_on "openssl@1.1"

  def install
    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
    system "make", "install", "PREFIX=#{prefix}"

    # Remove openssl cellar references, which breaks kore on openssl updates
    openssl = Formula["openssl@1.1"]
    inreplace [pkgshare/"features", pkgshare/"linker"], openssl.prefix.realpath, openssl.opt_prefix if OS.mac?
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end

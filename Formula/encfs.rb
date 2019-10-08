class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  revision 3
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "c41dd4f6c6eae27645695e7540a6e1ec25cd4a15756e5f5ed97a345cd39372fc" => :catalina
    sha256 "1cc308274ff04d95ab12bc39be227517dbf264e5cf811d72b153d6f84b06c0cb" => :mojave
    sha256 "137944ecee75c5d82634bf1458316c4d64d841ed9f92a4638ad266503f92b66f" => :high_sierra
    sha256 "79e5d3548036ae74ed956bea6d9c4ab7f2e12faf7b49b541da9a72476159a557" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"
  depends_on :osxfuse

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end

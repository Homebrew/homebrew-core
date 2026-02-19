class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/symas-embedded-database-lmdb"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.35/openldap-LMDB_0.9.35.tar.bz2"
  sha256 "98e28ab0a5c23fb2eb8ad12c12d7ad5fc5e4c3563f41d0b91e9420a075974d6f"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff8ea47014d75d42bf16d283dadd6b342953175fda71ec580cba3751ffbf14c9"
    sha256 cellar: :any,                 arm64_sequoia: "5fd57c67d053246fc8f47f996feb06226fb6532f7ee474b4e4ed125b4b647b85"
    sha256 cellar: :any,                 arm64_sonoma:  "7f3c10a0579bd56cc9d0d73ca40c908ab67c9c428e1e4357b3610da9359e46d5"
    sha256 cellar: :any,                 sonoma:        "74efd6cfd1355ccd8f1ea00232c9a163b939999fb209fc04111f622c9a59231b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "438f6fde81f43d28c4774ab7e5bfcc907c5c2093b5fdf636aa3ef4e4af75adb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aedd3488e577959f8e83ad4d26329e3d5c878e3c6be837d5d09ae7e5012756ff"
  end

  depends_on "pkgconf" => :test

  def install
    cd "libraries/liblmdb" do
      args = []
      args << "SOEXT=.dylib" if OS.mac?
      system "make", *args
      system "make", "install", *args, "prefix=#{prefix}"
    end

    (lib/"pkgconfig/lmdb.pc").write pc_file
    (lib/"pkgconfig").install_symlink "lmdb.pc" => "liblmdb.pc"
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=${prefix}/lib
      includedir=${prefix}/include

      Name: lmdb
      Description: #{desc}
      URL: #{homepage}
      Version: #{version}
      Libs: -L${libdir} -llmdb
      Cflags: -I${includedir}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")

    # Make sure our `lmdb.pc` can be read by `pkg-config`.
    system "pkg-config", "lmdb"
  end
end

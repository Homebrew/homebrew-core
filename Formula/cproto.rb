class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7m.tgz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cproto/cproto_4.7m.orig.tar.gz"
  sha256 "4b482e80f1b492e94f8dcda74d25a7bd0381c870eb500c18e7970ceacdc07c89"

  bottle do
    cellar :any_skip_relocation
    sha256 "b19c734b22ab4d5ad304fdb82e2d4b1fea25d0d1d8d3ccb1337adef143cf36d7" => :mojave
    sha256 "4f557a3b96ce60956b1fed9abc873f9bd844ca93492731db3971fd0ada78fa15" => :high_sierra
    sha256 "4dcee9160c276855b7bd94235dc15e4d153c161b4f81f8a1e041fda8da5b4cc7" => :sierra
    sha256 "21d0972269ad52cd7098b921f2500bb8bf827fabe1e0718c24fdfd2d844b7f7e" => :el_capitan
    sha256 "4bd2276c002322ce4d28030d60c0858e1efd4311e0f9de5460917cc5b70bc362" => :yosemite
    sha256 "a73eaa28daa6281fc987fb22b2bb50bd9962f4a4d4857e7371b8edf605822ca7" => :mavericks
    sha256 "8eedeacb18a2f3316171a4646f2a7cd2ec993005fd3a930072fbbc9fbd76c598" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end

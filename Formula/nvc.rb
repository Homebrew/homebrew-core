class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.1.0/nvc-1.1.0.tar.gz"
  sha256 "b3b5f67ee91046ab802112e544b7883f7a92b69d25041b5b8187c07016dfda75"

  bottle do
    sha256 "1e9c83fa64952cccf301e1652516697c6ab9e17a3d05e6f5f3861cb97689f1c0" => :sierra
    sha256 "05d0071242e0e8cc1621e3ac0ea1e8b5bcdcfbfe9622db9bef8a7a3077c39983" => :el_capitan
    sha256 "1b530bdf998bb161222efaae1ee59fe135889d6ed245f28dd2cee06e845ddc0e" => :yosemite
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  # LLVM 3.9 compatibility
  # Fix "Undefined symbols for architecture x86_64: '_LLVMLinkModules'"
  # Reported 8 Jan 2017 https://github.com/nickg/nvc/issues/310
  patch :DATA

  def install
    args = %W[
      --with-llvm=#{Formula["llvm"].opt_bin}/llvm-config
      --prefix=#{prefix}
    ]

    system "./autogen.sh" unless build.stable?
    system "./tools/fetch-ieee.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end

__END__
diff --git a/src/link.c b/src/link.c
index 850de56..2592b84 100644
--- a/src/link.c
+++ b/src/link.c
@@ -158,8 +158,8 @@ static void link_context_bc_fn(lib_t lib, tree_t unit, FILE *deps)
          tree_remove_attr(unit, llvm_i);

       char *outmsg;
-      if (LLVMLinkModules(module, src, LLVMLinkerDestroySource, &outmsg))
-         fatal("LLVM link failed: %s", outmsg);
+      if (LLVMLinkModules2(module, src))
+         fatal("LLVM link failed");
    }
 }

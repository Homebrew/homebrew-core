class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.16.tar.gz"
  sha256 "f4e27357aba6d5a69ab473e53a93353f9bed1a7e8ee43a6d8e186770d6a79586"
  license "GPL-2.0-only"

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "gnu-sed" => :build

    # skip building archscripts which have host system dependencies
    patch :DATA
  end

  def install
    on_macos do
      ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    end

    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end

__END__
diff --git a/Makefile b/Makefile
index 9e73f82e0..d824dd2ab 100644
--- a/Makefile
+++ b/Makefile
@@ -1289,7 +1289,7 @@ PHONY += archheaders archscripts
 hdr-inst := -f $(srctree)/scripts/Makefile.headersinst obj

 PHONY += headers
-headers: $(version_h) scripts_unifdef uapi-asm-generic archheaders archscripts
+headers: $(version_h) scripts_unifdef uapi-asm-generic archheaders
 	$(if $(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/Kbuild),, \
 	  $(error Headers not exportable for the $(SRCARCH) architecture))
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi
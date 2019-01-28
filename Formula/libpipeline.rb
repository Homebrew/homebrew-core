class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "http://libpipeline.nongnu.org/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.1.tar.gz"
  sha256 "d633706b7d845f08b42bc66ddbe845d57e726bf89298e2cee29f09577e2f902f"

  depends_on "pkg-config"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include <pipeline.h>
      int main(void)
      {
        pipeline *p = pipeline_new_command_args("true", NULL);
        int status = pipeline_run(p);
        return status;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lpipeline", "-I#{include}", "-o", "test"
    system "./test"
  end
end

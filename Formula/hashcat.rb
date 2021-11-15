class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.4.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.2.4.tar.gz"
  sha256 "9020396ff933693e310b479b641e86f1783d9819d60d1d907752ad8d24a60c31"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 arm64_monterey: "548332afa0203273e4d9a1a52409236142e24eb7e747a8fd33b4a9b298c9ef46"
    sha256 arm64_big_sur:  "7b9727bdfbc0a602aa7ce3b0430b0d12fddb46a78e7f9077d79a1cf6dbbc0313"
    sha256 monterey:       "0736726f1d60e51e6c42b8cf34dd87fda5dfa4924cd3d892eda6f4f698d4da86"
    sha256 big_sur:        "21a36b5a036e7f52c7bc47427d0451a33abd3ee08066961c33bc0f04494af847"
    sha256 catalina:       "84636fb6c2606364c8516346782758641c0c5bb5567936ada4fa2504ea75307e"
  end

  depends_on "gnu-sed" => :build

  # fixed for next version with https://github.com/hashcat/hashcat/pull/3030
  patch :DATA if Hardware::CPU.arm?

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0 -D 1,2 -w 2"
  end
end

__END__
diff --git a/src/backend.c b/src/backend.c
index 5de908202..6d0ba4695 100644
--- a/src/backend.c
+++ b/src/backend.c
@@ -10531,6 +10531,7 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
 
       int CL_rc;
 
+/*
       cl_program p1 = NULL;
 
       if (hc_clCreateProgramWithSource (hashcat_ctx, device_param->opencl_context, 1, (const char **) kernel_sources, NULL, &p1) == -1) return false;
@@ -10538,6 +10539,15 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
       CL_rc = hc_clCompileProgram (hashcat_ctx, p1, 1, &device_param->opencl_device, build_options_buf, 0, NULL, NULL, NULL, NULL);
 
       hc_clGetProgramBuildInfo (hashcat_ctx, p1, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, 0, NULL, &build_log_size);
+*/
+
+      if (hc_clCreateProgramWithSource (hashcat_ctx, device_param->opencl_context, 1, (const char **) kernel_sources, NULL, opencl_program) == -1) return false;
+
+      CL_rc = hc_clBuildProgram (hashcat_ctx, *opencl_program, 1, &device_param->opencl_device, build_options_buf, NULL, NULL);
+
+      if (CL_rc == -1) return -1;
+
+      hc_clGetProgramBuildInfo (hashcat_ctx, *opencl_program, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, 0, NULL, &build_log_size);
 
       #if defined (DEBUG)
       if ((build_log_size > 1) || (CL_rc == -1))
@@ -10547,7 +10557,9 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
       {
         char *build_log = (char *) hcmalloc (build_log_size + 1);
 
-        const int rc_clGetProgramBuildInfo = hc_clGetProgramBuildInfo (hashcat_ctx, p1, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, build_log_size, build_log, NULL);
+//        const int rc_clGetProgramBuildInfo = hc_clGetProgramBuildInfo (hashcat_ctx, p1, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, build_log_size, build_log, NULL);
+
+        const int rc_clGetProgramBuildInfo = hc_clGetProgramBuildInfo (hashcat_ctx, *opencl_program, device_param->opencl_device, CL_PROGRAM_BUILD_LOG, build_log_size, build_log, NULL);
 
         if (rc_clGetProgramBuildInfo == -1)
         {
@@ -10565,6 +10577,7 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
 
       if (CL_rc == -1) return false;
 
+/*
       cl_program t2[1];
 
       t2[0] = p1;
@@ -10579,7 +10592,7 @@ static bool load_kernel (hashcat_ctx_t *hashcat_ctx, hc_device_param_t *device_p
       *opencl_program = fin;
 
       hc_clReleaseProgram (hashcat_ctx, p1);
-
+*/
       if (cache_disable == false)
       {
         size_t binary_size;

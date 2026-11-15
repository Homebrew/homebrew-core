class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  stable do
    url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v26.3.tar.gz"
    sha256 "3a6a2a7c8bf5e7156dacb563e76d65df4aa53390e24040115c4406771ec3a19b"

    # Backport const-correctness changes from
    # https://github.com/nzbgetcom/nzbget/commit/f81d3f4de58fbfae9e0657a7eb3041ff6ab5adfd
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d6cd2be80c4eed77d5eedaaa2749fadca1255e924def4ac12507e0664b1ecf94"
    sha256 cellar: :any, arm64_tahoe:       "928e9f4486cf45d1806ef6dee8a99d6de7f38c656217c5c9b51ed7ca8e3b8d3a"
    sha256 cellar: :any, arm64_sequoia:     "2e962f0bf0eefbcf4dd5e914b14a38f884cee57fa283903276e4310c6cea12f9"
    sha256 cellar: :any, arm64_linux:       "635e164164e9a637190c8ccec96ce07d7c603c724355451edf5abe2e71ee31fa"
    sha256 cellar: :any, x86_64_linux:      "e6e92c83062f465de2123529aecac0e28c691b15310d262a31e514994cefac32"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@4"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "nzbget.conf" do |s|
      if OS.mac?
        # Set upstream's recommended values for file systems without
        # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
        s.gsub! "DirectWrite=yes", "DirectWrite=no"
        s.gsub! "ArticleCache=0", "ArticleCache=700"
      end

      # Update 7z cmd to match homebrew binary
      s.gsub! "SevenZipCmd=7z", "SevenZipCmd=7zz"
    end

    etc.install "nzbget.conf"
  end

  service do
    run [opt_bin/"nzbget", "-c", HOMEBREW_PREFIX/"etc/nzbget.conf", "-s", "-o", "OutputMode=Log",
         "-o", "ConfigTemplate=#{HOMEBREW_PREFIX}/share/nzbget/nzbget.conf",
         "-o", "WebDir=#{HOMEBREW_PREFIX}/share/nzbget/webui"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system bin/"nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system bin/"nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system bin/"nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end

__END__
diff --git a/daemon/connect/TlsSocket.cpp b/daemon/connect/TlsSocket.cpp
index 686032984..241832ddd 100644
--- a/daemon/connect/TlsSocket.cpp
+++ b/daemon/connect/TlsSocket.cpp
@@ -258,11 +258,11 @@ bool TlsSocket::ValidateCert()
 		if (common_name_loc >= 0)
 		{
 			// Extract the CN field
-			X509_NAME_ENTRY* common_name_entry = X509_NAME_get_entry(X509_get_subject_name(cert.get()), common_name_loc);
+			const X509_NAME_ENTRY* common_name_entry = X509_NAME_get_entry(X509_get_subject_name(cert.get()), common_name_loc);
 			if (common_name_entry != nullptr)
 			{
 				// Convert the CN field to a C string
-				ASN1_STRING* common_name_asn1 = X509_NAME_ENTRY_get_data(common_name_entry);
+				const ASN1_STRING* common_name_asn1 = X509_NAME_ENTRY_get_data(common_name_entry);
 				if (common_name_asn1 != nullptr)
 				{
 					certHost = ASN1_STRING_get0_data(common_name_asn1);

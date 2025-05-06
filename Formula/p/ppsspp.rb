class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  revision 3
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  # TODO: Can remove CMAKE_POLICY_VERSION_MINIMUM when bumping version to 1.18+
  # https://github.com/hrydgard/ppsspp/commit/fe91f246b2d22a25fcd52deb57211f1e86717c35
  stable do
    url "https://github.com/hrydgard/ppsspp/releases/download/v1.17.1/ppsspp-1.17.1.tar.xz"
    sha256 "23e0b8649cc8124b0c22a62d4d41b592b6bd4064bce8c09b0d4abce895e132ae"

    # miniupnpc 2.2.8 compatibility patch
    patch :DATA
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "11a86d48ffacea0abad6d65685f44e569be22641d643450ca1f4bfb78d711033"
    sha256 cellar: :any, arm64_sonoma:  "3b1a983666fa0dd5c9aac25279414f33adeb30782d4a62f35e13f6494dc65b50"
    sha256 cellar: :any, arm64_ventura: "32cdd20ec459258c4164f679fe9c2e4565d91ac3e38b52a261070e345f2611f1"
    sha256 cellar: :any, sonoma:        "7a107b64aa9e2360810677ddc833e1651cdaed20c1083612110074fc44463283"
    sha256 cellar: :any, ventura:       "83f5f34097a2800f0b52f2b754b90c3624fdcd61acaf8a4372963d8de955d64e"
    sha256               arm64_linux:   "e60baf589f6ffdc362c9ce45666c2ad54979d4b3f862d45af88c55992e14feb2"
    sha256               x86_64_linux:  "3b2eb05c61f97055537b379b39ccf2154e15f5b099d8f337d78f5a01f02c67ac"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build

  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "glew"
    depends_on "mesa"
  end

  on_intel do
    # ARM uses a bundled, unreleased libpng.
    # Make unconditional when we have libpng 1.7.
    depends_on "libpng"
  end

  def install
    # Build PPSSPP-bundled ffmpeg from source. Changes in more recent
    # versions in ffmpeg make it unsuitable for use with PPSSPP, so
    # upstream ships a modified version of ffmpeg 3.
    # See https://github.com/Homebrew/homebrew-core/issues/84737.
    cd "ffmpeg" do
      if OS.mac?
        rm_r("macosx")
        system "./mac-build.sh"
      else
        rm_r("linux")
        arch = Hardware::CPU.intel? ? "x86-64" : Hardware::CPU.arch
        system "./linux_#{arch}.sh"
      end
    end

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    vulkan_frameworks = buildpath/"ext/vulkan/macOS/Frameworks"
    vulkan_frameworks.install_symlink Formula["molten-vk"].opt_lib/"libMoltenVK.dylib"

    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DUSE_SYSTEM_LIBZIP=ON
      -DUSE_SYSTEM_SNAPPY=ON
      -DUSE_SYSTEM_LIBSDL2=ON
      -DUSE_SYSTEM_LIBPNG=ON
      -DUSE_SYSTEM_ZSTD=ON
      -DUSE_SYSTEM_MINIUPNPC=ON
      -DUSE_WAYLAND_WSI=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      prefix.install "build/PPSSPPSDL.app"
      bin.write_exec_script prefix/"PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"

      # Replace app bundles with symlinks to allow dependencies to be updated
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      ln_sf (Formula["molten-vk"].opt_lib/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
    else
      system "cmake", "--install", "build"
    end

    bin.install_symlink "PPSSPPSDL" => "ppsspp"
  end

  test do
    system bin/"ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_path_exists app_frameworks/"libMoltenVK.dylib", "Broken linkage with `molten-vk`"
    end
  end
end

__END__
diff --git a/Core/Util/PortManager.cpp b/Core/Util/PortManager.cpp
index cfb81e9dbd..dfd6a8e583 100644
--- a/Core/Util/PortManager.cpp
+++ b/Core/Util/PortManager.cpp
@@ -48,7 +48,7 @@ std::thread upnpServiceThread;
 std::recursive_mutex upnpLock;
 std::deque<UPnPArgs> upnpReqs;
 
-PortManager::PortManager(): 
+PortManager::PortManager():
 	m_InitState(UPNP_INITSTATE_NONE),
 	m_LocalPort(UPNP_LOCAL_PORT_ANY),
 	m_leaseDuration("43200") {
@@ -99,7 +99,7 @@ bool PortManager::Initialize(const unsigned int timeout) {
 	int ipv6 = 0; // 0 = IPv4, 1 = IPv6
 	unsigned char ttl = 2; // defaulting to 2
 	int error = 0;
-	
+
 	VERBOSE_LOG(SCENET, "PortManager::Initialize(%d)", timeout);
 	if (!g_Config.bEnableUPnP) {
 		ERROR_LOG(SCENET, "PortManager::Initialize - UPnP is Disabled on Networking Settings");
@@ -161,9 +161,21 @@ bool PortManager::Initialize(const unsigned int timeout) {
 
 		// Get LAN IP address that connects to the router
 		char lanaddr[64] = "unset";
-		int status = UPNP_GetValidIGD(devlist, urls, datas, lanaddr, sizeof(lanaddr)); //possible "status" values, 0 = NO IGD found, 1 = A valid connected IGD has been found, 2 = A valid IGD has been found but it reported as not connected, 3 = an UPnP device has been found but was not recognized as an IGD
+
+		// possible "status" values:
+		// -1 = Internal error
+		//  0 = NO IGD found
+		//  1 = A valid connected IGD has been found
+		//  2 = A valid connected IGD has been found but its IP address is reserved (non routable)
+		//  3 = A valid IGD has been found but it reported as not connected
+		//  4 = an UPnP device has been found but was not recognized as an IGD
+#if (MINIUPNPC_API_VERSION >= 18)
+		int status = UPNP_GetValidIGD(devlist, urls, datas, lanaddr, sizeof(lanaddr), nullptr, 0);
+#else
+		int status = UPNP_GetValidIGD(devlist, urls, datas, lanaddr, sizeof(lanaddr));
+#endif
 		m_lanip = std::string(lanaddr);
-		INFO_LOG(SCENET, "PortManager - Detected LAN IP: %s", m_lanip.c_str());
+		INFO_LOG(SCENET, "PortManager - Detected LAN IP: %s (status=%d)", m_lanip.c_str(), status);
 
 		// Additional Info
 		char connectionType[64] = "";
@@ -206,7 +218,7 @@ bool PortManager::Add(const char* protocol, unsigned short port, unsigned short
 	char intport_str[16];
 	int r;
 	auto n = GetI18NCategory(I18NCat::NETWORKING);
-	
+
 	if (intport == 0)
 		intport = port;
 	INFO_LOG(SCENET, "PortManager::Add(%s, %d, %d)", protocol, port, intport);
@@ -325,7 +337,7 @@ bool PortManager::Restore() {
 				}
 			}
 			// Add the original owner back
-			r = UPNP_AddPortMapping(urls->controlURL, datas->first.servicetype, 
+			r = UPNP_AddPortMapping(urls->controlURL, datas->first.servicetype,
 				it->extPort_str.c_str(), it->intPort_str.c_str(), it->lanip.c_str(), it->desc.c_str(), it->protocol.c_str(), it->remoteHost.c_str(), it->duration.c_str());
 			if (r == 0) {
 				it->taken = false;
@@ -334,7 +346,7 @@ bool PortManager::Restore() {
 				ERROR_LOG(SCENET, "PortManager::Restore - AddPortMapping failed (error: %i)", r);
 				if (r == UPNPCOMMAND_HTTP_ERROR)
 					return false; // Might be better not to exit here, but exiting a loop will avoid long timeouts in the case the router is no longer reachable
-			}		
+			}
 		}
 	}
 	return true;
@@ -538,4 +550,3 @@ void UPnP_Remove(const char* protocol, unsigned short port) {
 	std::lock_guard<std::recursive_mutex> upnpGuard(upnpLock);
 	upnpReqs.push_back({ UPNP_CMD_REMOVE, protocol, port, port });
 }
-

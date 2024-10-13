class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.19.tar.gz"
  sha256 "33af3637f119a61c509c01d2f8f6cc3d8be76f49e850132f2860af142abf82a9"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27d84e42df62a0987a6a4e09e9c3ad889d34431aff518e8a4e2ba04f4deddd70"
    sha256 cellar: :any,                 arm64_sonoma:  "cc28e95d9eb3e6001f7a10ae55d78194c80ab9da0a845659ed297e63165387a3"
    sha256 cellar: :any,                 arm64_ventura: "c0c317cf03d4bc3ea06595498c4133a6e04754b139f9dc9a2df253f9e184aa7a"
    sha256 cellar: :any,                 sonoma:        "f185dcb4542baba50bb99074e22ac703830034a5606b77fcf6b8bffac874742c"
    sha256 cellar: :any,                 ventura:       "66a4fce1db1301186613ee23fc40d5564d87c6673443214315cb193aef2a2ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a0ead2e42e910ff18f0595a0a8d402fd1eef81556f8487f936ef8f21ac917af"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build

  # remove unsupported `--version-script` linker flag
  on_macos do
    patch :DATA
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DWITH_PLUGINS=OFF",
                    "-DWITH_WEBSOCKETS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make", "install"
  end

  def post_install
    (var/"mosquitto").mkpath
  end

  def caveats
    <<~EOS
      mosquitto has been installed with a default configuration file.
      You can make changes to the configuration by editing:
          #{etc}/mosquitto/mosquitto.conf
    EOS
  end

  service do
    run [opt_sbin/"mosquitto", "-c", etc/"mosquitto/mosquitto.conf"]
    keep_alive false
    working_dir var/"mosquitto"
  end

  test do
    quiet_system sbin/"mosquitto", "-h"
    assert_equal 3, $CHILD_STATUS.exitstatus
    quiet_system bin/"mosquitto_ctrl", "dynsec", "help"
    assert_equal 0, $CHILD_STATUS.exitstatus
    quiet_system bin/"mosquitto_passwd", "-c", "-b", "/tmp/mosquitto.pass", "foo", "bar"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

__END__
diff --git a/lib/CMakeLists.txt b/lib/CMakeLists.txt
index de53e8b..479b45d 100644
--- a/lib/CMakeLists.txt
+++ b/lib/CMakeLists.txt
@@ -106,7 +106,6 @@ set_target_properties(libmosquitto PROPERTIES
 	VERSION ${VERSION}
 	SOVERSION 1
 	LINK_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/linker.version
-	LINK_FLAGS "-Wl,--version-script=${CMAKE_CURRENT_SOURCE_DIR}/linker.version"
 )
 
 install(TARGETS libmosquitto

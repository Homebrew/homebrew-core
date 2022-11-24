class Pixiewps < Formula
  desc "Offline Wi-Fi Protected Setup brute-force utility"
  homepage "https://github.com/wiire-a/pixiewps"
  url "https://github.com/wiire-a/pixiewps/releases/download/v1.4.2/pixiewps-1.4.2.tar.xz"
  sha256 "c4dc0569e476ebdbd85992da2d1ff799db97ed0040da9dc44e13d08a97a9de1e"
  license "GPL-3.0-or-later"
  head "https://github.com/wiire-a/pixiewps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "721604be69bab25231f1bda20ed0f5c6f8dcb5a2788e2350c28726f86e043a1c"
    sha256 cellar: :any,                 arm64_monterey: "faac5957f271cf40bed4393b1bcaa534ddc451c86b3898063d8f0261ef6702d3"
    sha256 cellar: :any,                 arm64_big_sur:  "2f777465467b09513a89236e118390430e9f019a8df3cec11bf8984ebc2d1453"
    sha256 cellar: :any,                 ventura:        "5bca2f2fa9f976cb82339438061efabb2f6dc8c311d1aae97765890d00bba93e"
    sha256 cellar: :any,                 monterey:       "55bf66c8040b07df2441c3fcf7c13eb27686e4b9c9ca62daf74d57f144fa90f7"
    sha256 cellar: :any,                 big_sur:        "d714557686dab4f733d680e7d127452599a5bf9707941e275088848f2674070d"
    sha256 cellar: :any,                 catalina:       "30700b0eb892878e10b1a8bbc47188e8d9487c6f7afc7495050b4f0f5051dfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a93abb2c126230b4c9254243b6fc99b778fb0d4aa220d0296a02940a46865e"
  end

  depends_on "openssl@3"

  def install
    system "make", "PREFIX=#{prefix}", "OPENSSL=1", "install"
  end

  test do
    output = shell_output("#{bin}/pixiewps \
-a 7f:de:11:b9:69:1c:de:26:4a:21:a4:6f:eb:3d:b8:aa:aa:d7:30:09:09:32:b8:24:43:9b:e0:91:78:e7:6f:2c \
-e d4:38:91:0d:4e:6e:15:fe:70:f0:97:a8:70:2a:b8:94:f5:75:74:bf:64:19:9f:92:82:9b:e0:2c:c0:a3:75:48\
:08:8f:63:0a:82:37:0c:b7:95:42:cf:55:ca:a5:f0:f7:6c:b2:c7:5f:0e:23:18:44:f4:2d:00:f1:da:d4:94:23:56\
:c7:2c:b0:f6:87:c7:77:d0:cc:11:35:cf:b7:4f:bc:44:8d:ca:35:8a:78:3d:99:7f:2b:cf:44:21:d8:e2:0f:3c:7d\
:a4:72:c8:03:6f:77:2a:e9:fa:c1:e9:a8:2c:74:65:99:5a:e0:a5:26:d9:23:5e:4e:ec:5a:07:07:ab:80:db:3f:5f\
:18:7f:fa:fa:f1:57:74:b2:8d:a9:97:a6:c6:0a:a5:e0:ec:93:09:23:67:f6:3e:ec:1f:55:32:a4:5d:73:8f:ab:91\
:74:cf:1d:79:85:12:c1:81:f5:ea:a6:68:9d:8e:c7:c6:be:01:dc:d9:f8:68:80:11:55:d7:44:6a \
-r bc:ad:54:2f:88:44:7c:12:69:ef:34:31:4a:17:1c:92:b1:d7:06:4c:73:be:9f:d3:ed:87:63:74:10:46:0f:46\
:8c:36:b5:d4:a0:ba:af:85:9c:b2:30:42:d7:59:43:75:5a:d7:79:96:fb:ee:7b:66:db:b7:a8:f9:22:9c:a5:d3:b8\
:e7:c0:c4:5c:58:34:1f:56:a8:1a:41:a8:d2:e8:f6:3e:c9:3a:93:d9:9b:59:5c:a8:e0:78:84:6c:fc:05:e8:76:a3\
:e6:3b:33:94:4a:a9:ff:50:fb:60:fa:97:3b:6d:cc:04:f1:5e:36:24:a9:06:7a:f8:6b:00:e9:71:9d:89:be:9c:b2\
:9c:1f:ca:6d:d6:4d:ab:46:3d:b3:11:1f:8d:40:f7:c8:a4:39:48:c5:ca:1b:f6:30:95:7d:d9:68:41:ef:0a:37:b2\
:4a:37:e4:a4:b0:dd:7e:c1:af:3e:66:ea:bf:16:0a:7a:8a:05:00:01:a4:29:77:a9:d4:81:d4:0e \
-s 90:5f:f5:7d:93:e5:c4:3c:62:0d:26:65:dd:59:57:d5:ba:ba:f1:b7:30:91:72:7c:54:94:38:08:1e:13:35:38 \
-z b0:2b:07:50:28:e7:6e:5f:fa:27:1b:31:92:85:43:cb:c5:6a:ec:73:e2:27:c3:b9:80:ec:5b:ed:88:f0:1e:ec \
-n 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00")
    assert_match "WPS pin:  04847533", output
  end
end

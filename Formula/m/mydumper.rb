class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.17.1-1.tar.gz"
  sha256 "bb13ab9214ae0af30fe0c4a5fcdcbc03d74261224d5d3fc2c9b8d106c0b637be"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8fa1982fc7ca287b17004b4f13618586439c30f25ce6013e98f464d7e48e994a"
    sha256 cellar: :any,                 arm64_sonoma:  "8b7ea1a0bf006c68d9416faac252bbe70d1ff106d4c39356dfec72c03885fd81"
    sha256 cellar: :any,                 arm64_ventura: "277c30d5539d7ac193b3375b2e34b8572a6fdecc0c0835cf29562e9695b82b09"
    sha256 cellar: :any,                 sonoma:        "00dad9a0db7eb680d61752c109f88357adab4052053f1f6346aae13adbe51edd"
    sha256 cellar: :any,                 ventura:       "540af04cf760f7188f49e9574e1c771dcf2fbe4fa51f67f556b1cb5cd9e73d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b25ca2e96058590ca0ed8fac16982772ae8398146cf728e52bf68e25dc3128"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre"

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = ["-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mydumper", "--help"
  end
end

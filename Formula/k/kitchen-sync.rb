class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.18.tar.gz"
  sha256 "088908d9a2cd5155245cf7bf8823859b0cf7e8901c5f97843c863f8e344fdc5b"
  license "MIT"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c863227af9560bcf1e41955e1ad4484512da86d086d4e1cf1350cd4e5d40b1e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c8c1afad3013a4233757efafbfd32cc8e8d6b94068e884996c03f0dad52f9d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44bdde825d8375a6c6d7c7a0bf834d06695cdaf436c85750ccfc79f21f7369fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a786e565cb1b1770511a217878a5dd3728f36335ee9e862afff6d83c05e3228c"
    sha256 cellar: :any,                 sonoma:         "b4c172159119eaaf09a31daf3763464951b60e27453148983b4455fcbe5f4bc6"
    sha256 cellar: :any_skip_relocation, ventura:        "83052f69c05a9b25d7c46ea2c6696948d20f28b5202368fbc4c6712d4a66a495"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4b73b92a02c79ef17eb8b60e426a7e550cddd0f45292588e84ef8856af0645"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ba2d74630f9db7e8b0dba3f3b2e0e863d275b8786d0aa499ae6004d2f117209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e70d05c091e1028e66d5b07762034f2e8aa6d85c07ee4255a275e793255bf716"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  fails_with gcc: "5"

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from mysql://b/ --to mysql://d/ 2>&1", 1)

    assert_match "Unknown MySQL server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end

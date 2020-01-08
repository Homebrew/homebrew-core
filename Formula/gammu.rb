class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.41.0.tar.xz"
  sha256 "8426b69b07b259de301f41163fab5587935e27b94cc5eefab9277773b3e4df8f"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "31de777eebd433187faa9f4c903e9adee6f1fc7376764819e88bf6564dec7095" => :catalina
    sha256 "e9436fa704b9bb1008b95f742b59f830a7fd717c24c97565f71989273a6eef58" => :mojave
    sha256 "fb23d0dd21c8a5f48155b3ea71f445d99ea86ce7f5c968266782fa52990a6267" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    # Disable opportunistic linking against Postgres
    inreplace "CMakeLists.txt", "macro_optional_find_package (Postgres)", ""
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end

class Granite < Formula
  desc "GTK+ extensions for elementary OS"
  homepage "https://launchpad.net/granite"
  url "https://launchpad.net/granite/0.3/0.3.1/+download/granite-0.3.1.tar.xz"
  sha256 "8ec1d61f9aba75f1b3a745e721288b0dfb34cb11d1307be80cef7b0571c2dec6"

  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "cmake" => :build
  depends_on "vala" => :build

  # patch for https://bugs.launchpad.net/granite/+bug/1581531
  patch :p0 do
    url "https://gist.githubusercontent.com/TuurDutoit/4997904aa5fec96c8f188d88615edbeb/raw/32916b507f7e6918d207279f66fbb8655f173fea/granite-0.3.1-1581531.patch"
    sha256 "fe87cbf98823369a5c918f068a2a135c77f276a8ef6d0f217f4682346e629110"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.vala").write <<-EOS.undent
      using Granite;
      int main (string[] args) {
        var time_format = Granite.DateTime.get_default_time_format ();
        return 0;
      }
    EOS

    system "valac", "--pkg", "gtk+-3.0", "--pkg", "granite", "test.vala"
    system "./test"
  end
end

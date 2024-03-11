class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.2.3/libpaper-2.2.3.tar.gz"
  sha256 "610912042e1f16d44738c2edf9886b9b1e3f5cd6e358ebacf6a62236ac4f0ee6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "9e2bb84c39c6ac442d320dd459ac899f4f1442750c6613d6cfede72c3d065fc7"
    sha256 arm64_ventura:  "7ad4cfa3e0d56d34210369df97c926d163d7f98a30f08006439663b2bc3fa9d5"
    sha256 arm64_monterey: "93d3f2cc58d8d5a0515e3f509050ada1a3be97591551df202f8afb5a9433c33e"
    sha256 sonoma:         "958c82b22d1b105e5b9b1c5b32534617315c6f4c2b5a31afb56629c8f29615e0"
    sha256 ventura:        "1f87c36d657c2466b03d313e5a8d08f74d5fc095e95f356582028e8664d0f7ce"
    sha256 monterey:       "7291eee5a6ddf3e7c2f6e092a4ad7274a62276e6ae682ddc6664663ec2cbfdb3"
    sha256 x86_64_linux:   "598a2eae7287ee4c47d155244b7f204c4ed2493699b89a0befbb1bad82a7479e"
  end

  depends_on "help2man" => :build

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    assert_match "A4: 210x297 mm", shell_output("#{bin}/paper --all")
    assert_match "paper #{version}", shell_output("#{bin}/paper --version")

    (testpath/"test.c").write <<~EOS
      #include <paper.h>
      int main()
      {
        enum paper_unit unit;
        int ret = paperinit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaper", "-o", "test"
    system "./test"
  end
end

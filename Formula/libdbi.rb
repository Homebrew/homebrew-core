class Libdbi < Formula
  desc "Database-independent abstraction layer in C, similar to DBI/DBD in Perl"
  homepage "https://libdbi.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libdbi/libdbi/libdbi-0.9.0/libdbi-0.9.0.tar.gz"
  sha256 "dafb6cdca524c628df832b6dd0bf8fabceb103248edb21762c02d3068fca4503"
  license "LGPL-2.1"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "65d1ef64a864021ad09a860db2dc4388216dc840d565c7a9a1e24e6dfe5b30e8"
    sha256 cellar: :any,                 arm64_monterey: "3e46a3c790195ad94277912f505bce7d29aee03dddc112f1473e5094b6f1de97"
    sha256 cellar: :any,                 arm64_big_sur:  "61c6d495c3d1459c663a25e3436401f57a4b8df6745befa5214076fa3555979e"
    sha256 cellar: :any,                 ventura:        "31885b42cd8d58dfc149999219b6b741aee0fab16c19f1e6d9f60b5b2d7c9376"
    sha256 cellar: :any,                 monterey:       "4a524cd1c3ee5cb9c053b01f01125ecca43d4def593b5afcca64b84307dcf505"
    sha256 cellar: :any,                 big_sur:        "af53bebb0b59917b87468a5cc52b168c01e40b83c5eff987ffa2655c9e64ac3b"
    sha256 cellar: :any,                 catalina:       "ce66e90000681c5f9174c3698ac4ceefd5d1be6ca4ffa574053f0705217c6837"
    sha256 cellar: :any,                 mojave:         "3aff10515535dc3f99dfa56644229daba74f719838d3e580754b3bbdc3c0429d"
    sha256 cellar: :any,                 high_sierra:    "eb3d8474601267d835b74b5a29944dc6d987486745dcfd17389be3a44b2c0175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0e87e837a96a2147f0f95157ecbf6df333145cbbbfec466a9c18d794ffe8c1"
  end

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        (buildpath/fn).unlink
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dbi/dbi.h>
      int main(void) {
        dbi_inst instance;
        dbi_initialize_r(NULL, &instance);
        printf("dbi version = %s\\n", dbi_version());
        dbi_shutdown_r(instance);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldbi", "-o", "test"
    system "./test"
  end
end

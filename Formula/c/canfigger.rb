class Canfigger < Formula
  desc "Simple configuration file parser library"
  homepage "https://github.com/andy5995/canfigger/"
  url "https://github.com/andy5995/canfigger/releases/download/v0.2.0/canfigger-0.2.0.tar.xz"
  sha256 "c43449d5f99f4a5255800c8c521e3eaec7490b08fc4363f2858ba45c565a1d23"
  license "GPL-3.0-or-later"
  head "https://github.com/andy5995/canfigger.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "88a1d1876a2750cab34159cf6d8a98db78db4e5825971ae02d04abd3d0338b76"
    sha256 cellar: :any,                 arm64_monterey: "1d7a8ff435adffd2eb0f02c510a0bab42cf4524cb21c167c81ef8dd47f29e3aa"
    sha256 cellar: :any,                 arm64_big_sur:  "5d687946bd99e626086e252379010085cc1b988b75c47acaf4718eb340018ca7"
    sha256 cellar: :any,                 ventura:        "6d1522e15b022a559dce8a183722f7376e7f2e95bde9e936c984d8af3106d128"
    sha256 cellar: :any,                 monterey:       "0d9d2b353ff46ffef823eb199c8ea03d1c31f6bb627ff450ff7f96b8415ede65"
    sha256 cellar: :any,                 big_sur:        "ea8085a8731d33a9206068fb9df16dc80a7a17be1610e6f5597cfd774845c3af"
    sha256 cellar: :any,                 catalina:       "f05d18c0525c516674de0daf6d1c2322b12083785bdc8846f003d1e1b58d1b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ecec5f6717c2899f7f0a0875d0e49c0c2ad247b28641f51436b94e4e4995ce4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.conf").write <<~EOS
      Numbers = list, one , two, three, four, five, six, seven
    EOS
    (testpath/"test.c").write <<~EOS
      #include <canfigger.h>
      #include <stdio.h>
      #include <stdlib.h>
      #ifdef NDEBUG
      #undef NDEBUG
      #endif
      #include <assert.h>
      #include <string.h>
      int main()
      {
        st_canfigger_list *list = canfigger_parse_file ("test.conf", ',');
        st_canfigger_list *root = list;
        if (list == NULL)
        {
          fprintf (stderr, "Error");
          return -1;
        }
        assert (strcmp (list->key, "Numbers") == 0);
        assert (strcmp (list->value, "list") == 0);
        assert (strcmp (list->attr_node->str, "one") == 0);
        assert (strcmp (list->attr_node->next->str, "two") == 0);
        assert (strcmp (list->attr_node->next->next->str, "three") == 0);
        canfigger_free_attr (list->attr_node);
        canfigger_free (list);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcanfigger", "-o", "test"
    system "./test"
  end
end

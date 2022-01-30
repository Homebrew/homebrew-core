class Canfigger < Formula
  desc "Simple configuration file parser library"
  homepage "https://github.com/andy5995/canfigger/"
  url "https://github.com/andy5995/canfigger/releases/download/v0.2.0/canfigger-0.2.0.tar.xz"
  sha256 "c43449d5f99f4a5255800c8c521e3eaec7490b08fc4363f2858ba45c565a1d23"
  license "GPL-3.0-or-later"
  head "https://github.com/andy5995/canfigger.git", branch: "trunk"

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

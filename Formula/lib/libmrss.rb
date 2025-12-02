class Libmrss < Formula
  desc "C library for RSS files or streams"
  homepage "https://github.com/bakulf/libmrss"
  url "https://github.com/bakulf/libmrss/archive/refs/tags/0.19.4.tar.gz"
  sha256 "28022247056b04ca3f12a9e21134d42304526b2a67b7d6baf139e556af1151c6"
  license "LGPL-2.1-or-later"
  head "https://github.com/bakulf/libmrss.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ff549d15087ee2c00bcf2645bb8626106f785b8a351590211b3e95e9e10b5907"
    sha256 cellar: :any,                 arm64_sequoia:  "183934eb440639c9d4506bcc74cc7c86da915e1bc65d041d79ebbc6eff5f6f1b"
    sha256 cellar: :any,                 arm64_sonoma:   "b28e679db851fa12e08db6e3c5061cd7dc8daa31b8d39686ae4fc40f6e5164a7"
    sha256 cellar: :any,                 arm64_ventura:  "52dbc8575b256260ae711ff08c2a8fbd2bed6151c26fb65c872d7e4e97cfd0f6"
    sha256 cellar: :any,                 arm64_monterey: "fa6977b426f1dd8c129134839639658642a90927e2cc1094989dff78c0d05d9e"
    sha256 cellar: :any,                 sonoma:         "a3aeb6af0ab68d39a8e9dfb4d3b22501c4e84077d7ebf65cf8403f65db270f26"
    sha256 cellar: :any,                 ventura:        "1df7a24f602409e59cc256c621e83d69d50cd985d8ffe33398853676a1cbaa82"
    sha256 cellar: :any,                 monterey:       "f4b7cf45e3d2fcdafd282770ef575cbee21d8d9d5da4eadc34058adfb3c74ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3ae2132725abace2b6a09d82e011f722daf45abe1ec5bcda7fdc4f602a3ae099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d84960b66d364c0d2e8221bade1462f73eef410a6107e00a736235e1f2ec5b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libnxml"

  uses_from_macos "curl"

  def install
    # need NEWS file for build
    touch "NEWS"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <mrss.h>

      int main() {
        mrss_t *rss;
        mrss_error_t error;
        mrss_item_t *item;
        const char *url = "https://raw.githubusercontent.com/git/git.github.io/master/feed.xml";

        error = mrss_parse_url(url, &rss);
        if (error) {
            printf("Error parsing RSS feed: %s\\n", mrss_strerror(error));
            return 1;
        }

        for (item = rss->item; item; item = item->next) {
            printf("Title: %s\\n", item->title);
        }

        mrss_free(rss);

        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs mrss").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match "Title: {{ post.title | xml_escape}}", shell_output("./test")
  end
end

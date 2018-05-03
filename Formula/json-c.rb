class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.13.1-20180305.tar.gz"
  version "0.13.1"
  sha256 "5d867baeb7f540abe8f3265ac18ed7a24f91fe3c5f4fd99ac3caba0708511b90"

  bottle do
    cellar :any
    sha256 "b8f06e2b22f08912346e318cb293cc988a3fa3fe3de7ea2e3c84b2b52357ee6f" => :high_sierra
    sha256 "2ce9b90873fa07bcb526c7b9aea55e58af52d88402e891227a5927a41d525ef5" => :sierra
    sha256 "6055bdc414153c7928fa30f215e8354510d9610cb3b75c75def3e6850b48e11f" => :el_capitan
    sha256 "4e6850e0b1627f622b64ae270883df999ab986046b1d4f9f0ca446fbd24a729b" => :yosemite
  end

  head do
    url "https://github.com/json-c/json-c.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <json-c/json.h>

      int main() {
        json_object *obj = json_object_new_object();
        json_object *value = json_object_new_string("value");
        json_object_object_add(obj, "key", value);
        printf("%s\n", json_object_to_json_string(obj));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ljson-c", "test.c", "-o", "test"
    assert_equal '{ "key": "value" }', shell_output("./test").chomp
  end
end

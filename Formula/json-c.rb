class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.12-20140410.tar.gz"
  version "0.12"
  sha256 "99304a4a633f1ee281d6a521155a182824dd995139d5ed6ee5c93093c281092b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b61af7437b93495ba08b097e4da71e3c00f672402394620607977b45d2348f85" => :sierra
    sha256 "8ba8006e2eb97006a781ce8d93a95791ae1e26d094afce0aeb8483caa95febbd" => :el_capitan
    sha256 "f7a602faf71091f98eb7b8390c1bd36bbd14cfe7e20c2f418bcc5c797315a2be" => :yosemite
    sha256 "e755df0edf95cf76c20a551dd28bb1703e769371413feaa7f60660338a72ce6c" => :mavericks
    sha256 "df94de81086ff76a48531df981ea32390dbae338e93fc0e157efc97193cd1f74" => :mountain_lion
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
    (testpath/"test.c").write <<-'EOS'.undent
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

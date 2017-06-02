class Joshua < Formula
  desc "Statistical machine translation decoder."
  homepage "https://joshua.incubator.apache.org/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"
  head "https://git-wip-us.apache.org/repos/asf/incubator-joshua.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7b04fb7031b9f002a418eb7d674d2ceb05be0926c0a7d8abfea644be6d381df4" => :sierra
    sha256 "b649095ea4a944799fbc1ccd8425464b7d2711b0a149049b4d2d5e92d604c5ae" => :el_capitan
    sha256 "6ac9fb24f8b1bb70a32c72c8436b8ad43717cf83d65499cb011214061b6ce6ba" => :yosemite
    sha256 "176fa47a6a2722fb5b6bf1e2efba8da32bab6355f3d844424a817882ed7b3a8e" => :mavericks
  end

  option "with-ar-en-phrase-pack", "Build with Arabic–English phrase-based model [2.1G]."
  option "with-en-ru-phrase-pack", "Build with English-Russian hiero-based model [4.6G]."
  option "with-es-en-phrase-pack", "Build with Spanish–English phrase-based model [2.0G]."
  option "with-ru-en-phrase-pack", "Build with Russian-English heiro-based model [4.4G]."
  option "with-zh-en-hiero-pack", "Build with Chinese-English hiero-based model [2.4G]."

  depends_on :java => "1.8+"
  depends_on "maven" => :build
  depends_on "boost" => :build
  depends_on "md5sha1sum" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  resource "ar-en-phrase-pack" do
    url "https://cs.jhu.edu/~post/language-packs/language-pack-ar-en-phrase-2015-03-18.tgz"
    sha256 "2b6665b58b11e4c25d48191d3d5b62b7c591851a9767b14f9ccebf1951fddf90"
   end

  resource "en-ru-hiero-pack" do
    url "https://home.apache.org/~lewismc/language-pack-en-ru-2016-10-28.tar.gz"
    sha256 "ef41c9a258f7dc61190af809491e24ea3a7de199b59ebcbbc2b7eed158b5d9f3"
  end

  resource "es-en-phrase-pack" do
    url "http://cs.jhu.edu/~post/files/apache-joshua-es-en-2016-10-05.tgz"
    sha256 "dfc5856ec722cb48bbbedc548aea9ad017fdcbc0a460237156abf5b8fc1b864b"
  end

  resource "ru-en-hiero-pack" do
    url "https://home.apache.org/~lewismc/language-pack-ru-en-2016-11-04.tar.gz"
    sha256 "bf42ea5ecedb7cd992a44f95f73f1c26e73c91b8756edf4f8d50d1bbaaf9a351"
  end

  resource "zh-en-hiero-pack" do
    url "https://cs.jhu.edu/~post/language-packs/zh-en-hiero-2016-01-13.tgz"
    sha256 "ded27fe639d019c91cfefce513abb762ad41483962b957474573e2042c786d46"
  end

  def install
    rm Dir["lib/*.{gr,tar.gz}"]
    rm_rf "lib/README"
    rm_rf "bin/.gitignore"
    if build.head?
      ENV.java_cache
      system "mvn", "clean", "package", "-DskipTests"
    end
    if build.with? "ar-en-phrase-pack"
      resource("ar-en-phrase-pack").stage do
        (libexec/"language-pack-ar-en-phrase-2015-03-18").install Dir["*"]
      end
    end
    if build.with? "en-ru-hiero-pack"
      resource("en-ru-hiero-pack").stage do
        (libexec/"language-pack-en-ru-2016-10-28").install Dir["*"]
      end
    end
    if build.with? "es-en-phrase-pack"
      resource("es-en-phrase-pack").stage do
        (libexec/"apache-joshua-es-en-2016-10-05").install Dir["*"]
      end
    end
    if build.with? "ru-en-hiero-pack"
      resource("ru-en-hiero-pack").stage do
        (libexec/"language-pack-ru-en-2016-11-04").install Dir["*"]
      end
    end
    if build.with? "zh-en-hiero-pack"
      resource("zh-en-hiero-pack").stage do
        (libexec/"zh-en-hiero-pack-2016-01").install Dir["*"]
      end
    end
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    inreplace "#{bin}/bleu", "JOSHUA\=$(dirname $0)/..", "JOSHUA\=#{libexec}"
    inreplace "#{bin}/debug-joshua", "JOSHUA\=$(dirname $0)/..", "JOSHUA\=#{libexec}"
    inreplace "#{bin}/extract-1best", "JOSHUA\=$(dirname $0)/..", "JOSHUA\=#{libexec}"
    inreplace "#{bin}/joshua", "JOSHUA\=$(dirname $0)/..", "JOSHUA\=#{libexec}"
    inreplace "#{bin}/joshua-decoder", "JOSHUA\=$(dirname $0)/..", "JOSHUA\=#{libexec}"
  end

  test do
    assert_equal "test_OOV\n", pipe_output("#{libexec}/bin/joshua -v 0 -output-format %s -mark-oovs", "test")
  end
end

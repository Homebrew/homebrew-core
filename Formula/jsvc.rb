class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.3.3-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.3.3-src.tar.gz"
  sha256 "2791b377a47c08caa1b2044faeb1e10fffcb7697151102a7041ee2fe92cbf27b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb77518d9269c4e617e7b09201b02d647eeaf3680a1ad5d2a27fd78e7acbaea7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bc07fb1a8df28c25c34c937c31aefc69696fa943593a2a81569914f7c87bf9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7f99e70ffd0d8be7b7b0cba0620b2d561151686c251799362db6871fc8c149c"
    sha256 cellar: :any_skip_relocation, ventura:        "c81c89aa6d370c161c35ece2f2448e54eaf6a99a8af707da27a5cf64b2974ef4"
    sha256 cellar: :any_skip_relocation, monterey:       "86903cd2c0c38466cf36b1043276b2fa4cef696b0d9b1ef656b822100b768500"
    sha256 cellar: :any_skip_relocation, big_sur:        "00ee9d372a5dc1272070869ea47a571fdfa097137cfa540f7871cc03c3d323a5"
    sha256 cellar: :any_skip_relocation, catalina:       "615fa7df23a9d249ee94bc0e858d8ec676ce09a7ae3a299a301f19f32979a58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa83b6c6a3c3f886424185863216b1587a4400ef7ce1c83452ae312a552bab02"
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end

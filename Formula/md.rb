class Md < Formula
  desc "Process raw dependency files produced by cpp"
  homepage "https://opensource.apple.com/source/adv_cmds/adv_cmds-147/md/"
  url "https://opensource.apple.com/tarballs/adv_cmds/adv_cmds-147.tar.gz"
  sha256 "e74d93496dd031ffea1ad8995686c1e9369a92de70c4c95a7f6e3d6ce2e7e434"

  bottle do
    cellar :any_skip_relocation
    sha256 "919611448c8b0f207aa7c08ca3277b987623f7f17fe31a13c9bc0118f4c27f2b" => :catalina
    sha256 "a4d92767a1393d4eb0bf029d449e81b7c56ddacec1a7de5235ac5435a9b880e9" => :mojave
    sha256 "9ce0b54023eabc2b3aa46ee73ef3a36f1b0e5019b1d99cf822ae89c6840198a0" => :high_sierra
    sha256 "b4187ef160dfbdefabaa05abb5bc044560ccf27410dc92be160760ec1142279d" => :sierra
    sha256 "6d758b2227eec1332e56fac01eba034ace9df33c424cf8b96523d115342691ac" => :el_capitan
    sha256 "979e6070affecebf0bcddb24075a3e059c5e4880da1666bb3dc96608f5d7148a" => :yosemite
    sha256 "5faf5907b69c2a53c9bbbcfcb908d24c222181490b69116e09102212382be5ea" => :mavericks
  end

  def install
    cd "md" do
      system ENV.cc, ENV.cflags, "-o", "md", "md.c"
      bin.install "md"
      man1.install "md.1"
    end
  end

  test do
    (testpath/"foo.d").write "foo: foo.cpp\n"

    system "#{bin}/md", "-d", "-u", "Makefile", "foo.d"

    refute_predicate testpath/"foo.d", :exist?
    assert_predicate testpath/"Makefile", :exist?
    assert_equal "# Dependencies for File: foo:\nfoo: foo.cpp\n",
      File.read("Makefile")
  end
end

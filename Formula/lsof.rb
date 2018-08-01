class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  url "https://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.91.tar.bz2"
  sha256 "c9da946a525fbf82ff80090b6d1879c38df090556f3fe0e6d782cb44172450a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "553ae69481b898fa1125b5d9d97c51cf49c4c31f11e1fe5d33a86c415a845e8d" => :high_sierra
    sha256 "2312dceb501fa6d9301fa506370784456937404ac43381354457ce63d99ccd56" => :sierra
    sha256 "fb14a3aef899327098b92d6d2c283e8978fc34d55b42019b8a54338abe8d4853" => :el_capitan
    sha256 "8a63b65f74b992e4a70ac3e18a7e4b810a73e183b13086b40f30286256e646e0" => :yosemite
  end

  def install
    system "tar", "xf", "lsof_#{version}_src.tar"
    cd "lsof_#{version}_src" do
      inreplace "dialects/darwin/libproc/dfile.c",
                "#extern\tstruct pff_tab\tPgf_tab[];", "extern\tstruct pff_tab\tPgf_tab[];"

      ENV["LSOF_INCLUDE"] = "#{MacOS.sdk_path}/usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", "#{MacOS.sdk_path}/usr/include"

      mv "00README", "README"
      system "./Configure", "-n", "darwin"
      system "make"
      bin.install "lsof"
      man8.install "lsof.8"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end

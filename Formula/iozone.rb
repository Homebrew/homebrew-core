class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_487.tar"
  sha256 "2c488a7ccddd624fd557af16e71442c367b131d6178e1b4023bbd532bacdda59"

  bottle do
    cellar :any_skip_relocation
    sha256 "704c25cbbe9ac821b7f4bef8c23b5ac4df5117d15574062f77247769bca8e6ef" => :catalina
    sha256 "ed77f59ddfb45e302b60e80d2f4a842e838af5973df7e6dc7d95a3d27c06d0e8" => :mojave
    sha256 "c0f0f7a10f585f40435d1d0a07322739925c9cae2afeb8c8714fe9e121a41572" => :high_sierra
    sha256 "09eda4f32813be63ba4e05dee24a9cac6805667d022fb8a2ed42ef8b0fafe9dc" => :sierra
  end

  def install
    cd "src/current" do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end

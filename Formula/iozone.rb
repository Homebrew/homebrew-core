class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_493.tgz"
  sha256 "5a52f5017e022e737f5b55f320cc6ada0f2a8c831a5f996cce2a44e03e91c038"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7eaa434d74f43691c718d76c09f1b756fcee32ad96ba5042f69de9efa00f8e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d89148f54880ee8829237f33d129c5844d13ccda2621f1afd04ff715aaaa9521"
    sha256 cellar: :any_skip_relocation, monterey:       "53a4da234813b26c9647f81b3c2c3aa6cfe2288a8902c257d6b790418444e685"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d17f34feb80fd9906bfab67542f082232389be9ea7d6fc8e7c893cd858428a7"
    sha256 cellar: :any_skip_relocation, catalina:       "ef7631b9c8639f7e84b81e3dfcd99b6b0707fc27e4185e21f0126d9e625ca8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9aa1ad6e384d02895adf1b3afe200c886856982a7f42855602822fb3288bf76"
  end

  def install
    cd "src/current" do
      target = OS.mac? ? "macosx" : OS.kernel_name.downcase
      system "make", target, "CC=#{ENV.cc}"
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

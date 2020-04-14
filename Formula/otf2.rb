class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/"
  url "https://www.vi-hps.org/cms/upload/packages/otf2/otf2-2.2.tar.gz"
  sha256 "d0519af93839dc778eddca2ce1447b1ee23002c41e60beac41ea7fe43117172d"

  bottle do
    sha256 "24d03eef4fee4e1cf533f4f015a51d04ceb0d086f96f5f7d070b329b44938819" => :catalina
    sha256 "cd45334e8b465b0405d641311b000de22e99eb93abe863da642307144ad8122c" => :mojave
    sha256 "66e9193d40e126c83d98bca06d30bd18815fb4aebbd486ff8d59ad27724935aa" => :high_sierra
    sha256 "70db1872735f904393ff8b3d1395c40eed3201072c5f08ca1ca5235d40688d07" => :sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "gcc"
  depends_on "open-mpi"
  depends_on "python"

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("future").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["PYTHON"] = Formula["python"].opt_bin/"python3"
    ENV["SPHINX"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{share}/doc/otf2/examples", testpath
    workdir = testpath/"examples"
    chdir "#{testpath}/examples" do
      # build serial tests
      system "make", "serial", "mpi", "pthread"
      %w[
        otf2_mpi_reader_example
        otf2_mpi_reader_example_cc
        otf2_mpi_writer_example
        otf2_pthread_writer_example
        otf2_reader_example
        otf2_writer_example
      ].each { |p| assert_predicate workdir/p, :exist? }
      system "./otf2_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
      rm_rf "./ArchivePath"
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      (0...2).each do |n|
        assert_predicate workdir/"ArchivePath/ArchiveName/#{n}.evt", :exist?
      end
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_reader_example"
      system "./otf2_reader_example"
      rm_rf "./ArchivePath"
      system "./otf2_pthread_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
    end
  end
end

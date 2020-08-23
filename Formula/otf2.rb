class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/"
  url "https://www.vi-hps.org/cms/upload/packages/otf2/otf2-2.2.tar.gz"
  sha256 "d0519af93839dc778eddca2ce1447b1ee23002c41e60beac41ea7fe43117172d"
  revision 1

  bottle do
    sha256 "4c532e5cb9864669bc29b6ad5007669c92a6abb3e069d7904ab3b102169ec2bc" => :catalina
    sha256 "ec63ae3bd66e7231b05f6bbd5ce8b0606126ad25e871f59d9e066fa62b9e26d8" => :mojave
    sha256 "dbf4c3c761e51a184a675d369a54dea5247d25d96e78899ca3b268a04c629c48" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "gcc"
  depends_on "open-mpi"
  depends_on "python@3.8"

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  def install
    python3 = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("future").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["PYTHON"] = python3
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

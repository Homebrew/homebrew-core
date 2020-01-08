class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/"
  url "https://www.vi-hps.org/cms/upload/packages/otf2/otf2-2.1.1.tar.gz"
  sha256 "01591b42e76f396869ffc84672f4eaa90ee8ec2a8939755d9c0b5b8ecdcf47d3"

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
    url "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz"
    sha256 "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"
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

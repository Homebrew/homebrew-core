class Mumps < Formula
  desc "Parallel Sparse Direct Solver"
  homepage "http://mumps-solver.org"
  url "http://mumps.enseeiht.fr/MUMPS_5.1.2.tar.gz"
  sha256 "eb345cda145da9aea01b851d17e54e7eef08e16bfa148100ac1f7f046cd42ae9"

  depends_on "openblas"
  depends_on "gcc"
  depends_on "metis"

  resource "mumps_simple" do
    url "https://github.com/dpo/mumps_simple/archive/v0.4.tar.gz"
    sha256 "87d1fc87eb04cfa1cba0ca0a18f051b348a93b0b2c2e97279b23994664ee437e"
  end

  def install
    make_args = ["RANLIB=echo"]
    # Building dylibs with mpif90 causes segfaults on 10.8 and 10.10. Use gfortran.
    shlibs_args = ["LIBEXT=.dylib",
                   "AR=gfortran -dynamiclib -Wl,-install_name -Wl,#{lib}/$(notdir $@) -undefined dynamic_lookup -o "]
    make_args += ["OPTF=-O", "CDEFS=-DAdd_"]
    orderingsf = "-Dpord"

    makefile = "Makefile.G95.SEQ"
    cp "Make.inc/" + makefile, "Makefile.inc"

    make_args += ["LMETISDIR=#{Formula["metis"].opt_lib}",
                  "IMETIS=#{Formula["metis"].opt_include}",
                  "LMETIS=-L#{Formula["metis"].opt_lib} -lmetis"]
    orderingsf << " -Dmetis"

    make_args << "ORDERINGSF=#{orderingsf}"

    make_args += ["CC=#{ENV["CC"]}", "FC=gfortran", "FL=gfortran"]

    make_args << "LIBBLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"

    ENV.deparallelize # Build fails in parallel on Mavericks.

    system "make", "alllib", *(shlibs_args + make_args)

    lib.install Dir["lib/*"]
    lib.install "libseq/libmpiseq.dylib"

    # Build static libraries (e.g., for Dolfin)
    system "make", "alllib", *make_args
    (libexec/"lib").install Dir["lib/*.a"]
    (libexec/"lib").install "libseq/libmpiseq.a"

    inreplace "examples/Makefile" do |s|
      s.change_make_var! "libdir", lib
    end

    libexec.install "include"
    include.install_symlink Dir[libexec/"include/*"]
    # The following .h files may conflict with others related to MPI
    # in /usr/local/include. Do not symlink them.
    (libexec/"include").install Dir["libseq/*.h"]

    doc.install Dir["doc/*.pdf"]
    pkgshare.install "examples"

    prefix.install "Makefile.inc"  # For the record.
    File.open(prefix/"make_args.txt", "w") do |f|
      f.puts(make_args.join(" "))  # Record options passed to make.
    end
  end

  test do
    cp_r pkgshare/"examples", testpath
    opts = ["-I#{opt_include}", "-L#{opt_lib}", "-lmumps_common", "-lpord"]
    opts << "-L#{Formula["openblas"].opt_lib}" << "-lopenblas"
    cc = ENV["CC"]

    cd testpath/"examples" do
      system "gfortran", "-o", "ssimpletest", "ssimpletest.F", "-lsmumps", *opts
      system "./ssimpletest < input_simpletest_real"
      system "gfortran", "-o", "dsimpletest", "dsimpletest.F", "-ldmumps", *opts
      system "./dsimpletest < input_simpletest_real"
      system "gfortran", "-o", "csimpletest", "csimpletest.F", "-lcmumps", *opts
      system "./csimpletest < input_simpletest_cmplx"
      system "gfortran", "-o", "zsimpletest", "zsimpletest.F", "-lzmumps", *opts
      system "./zsimpletest < input_simpletest_cmplx"
      system ENV.cc, "-c", "c_example.c", "-I#{opt_include}"
      system "gfortran", "-o", "c_example", "c_example.o", "-ldmumps", *opts
      system "./c_example", *opts
    end
  end
end

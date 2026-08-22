class Gatk < Formula
  include Language::Python::Virtualenv

  desc "Genome Analysis Toolkit for variant discovery in sequencing data"
  homepage "https://gatk.broadinstitute.org/"
  url "https://github.com/broadinstitute/gatk/releases/download/4.7.0.0/gatk-4.7.0.0.zip"
  sha256 "d093d2693b1626361a413ca59d6d4a0bf968717f280a8fd9ce060b25eb2ed1db"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # For gfortran, which scipy links. Declared for every platform because
  # homebrew/core forbids a Linux-only dependency on GCC.
  depends_on "gcc"
  depends_on "libomp" # torch's OpenMP runtime, declared so `brew linkage` passes
  depends_on "openjdk@17"
  # gcnvkernel pins pytensor 2.18.1, which declares Requires-Python <3.12.
  depends_on "python@3.11"
  depends_on "r"

  uses_from_macos "bzip2" # for pysam's bundled htslib

  on_linux do
    # numpy, scipy, h5py, pillow and pysam ship manylinux wheels that link the
    # system zlib, directly or through vendored libraries (libgfortran,
    # libhdf5, libtiff, htslib, ...), which `brew linkage` rejects, so they are
    # built from source instead.
    depends_on "patchelf" => :build
    depends_on "freetype"
    depends_on "hdf5"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "little-cms2"
    depends_on "openblas"
    depends_on "webp"
    depends_on "xz" # for pysam's bundled htslib
    depends_on "zlib-ng-compat"
  end

  def install
    # The environment GATK's Python tools (the gCNV workflow, NVScoreVariants)
    # need. `venv.pip_install` forces --no-binary/--no-deps and torch cannot be
    # built from source here, so drive pip against the venv directly.
    python = formula_opt_libexec("python@3.11")/"bin/python"
    venv = virtualenv_create(libexec/"venv", python)

    # gcnvkernel's own setup.py and its import-time assertion pin the first
    # four; the rest of the environment is left to pip. fastprogress is held
    # back from the releases that depend on python-fasthtml, which drags in
    # uvicorn and its universal2 uvloop wheel.
    constraints = buildpath/"constraints.txt"
    constraints.write <<~EOS
      fastprogress==1.0.3
      numpy==1.26.2
      pymc==5.10.1
      pytensor==2.18.1
      scipy==1.11.4
      tqdm==4.66.1
    EOS
    pip = ["-m", "pip", "--python=#{venv.root}/bin/python", "install",
           "--constraint=#{constraints}"]
    # matplotlib pulls in fontTools, whose macOS wheels are universal2.
    from_source = ["--no-binary=fonttools"]
    if OS.linux?
      from_source = ["--no-binary=fonttools,numpy,scipy,h5py"]
      ENV["HDF5_DIR"] = formula_opt_prefix("hdf5")
      ENV["FC"] = formula_opt_bin("gcc")/"gfortran"
      # htslib links libcurl, and through it the whole TLS and Kerberos stack,
      # purely for remote file access that nothing here uses.
      ENV["HTSLIB_CONFIGURE_OPTIONS"] = "--disable-libcurl --disable-gcs --disable-s3"
      # Only the current python formula ships an unversioned `python3.pc`, so
      # meson would build numpy and scipy against its headers rather than the
      # venv's. Shadow it with one pointing at python@3.11.
      pkgconfig = buildpath/"pkgconfig"
      pkgconfig.mkpath
      %w[python3 python3-embed].each do |pc|
        pkgconfig.install_symlink formula_opt_lib("python@3.11")/
                                  "pkgconfig/#{pc.sub("python3", "python-3.11")}.pc" => "#{pc}.pc"
      end
      ENV.prepend_path "PKG_CONFIG_PATH", pkgconfig
    end

    if OS.linux?
      # PyPI's linux torch wheels are CUDA-only (multi-GB); use the CPU index.
      system python, *pip, "torch",
             "--index-url", "https://download.pytorch.org/whl/cpu",
             "--extra-index-url", "https://pypi.org/simple"
    else
      system python, *pip, "torch"
    end
    if OS.linux?
      # Pillow enables whichever optional codecs it happens to find in the build
      # environment, so pin them to the declared dependencies to keep the
      # bottle's linkage reproducible. It has to precede matplotlib, which would
      # otherwise pull a Pillow wheel.
      pillow = %w[zlib jpeg tiff freetype lcms webp].map { |f| "--config-settings=#{f}=enable" }
      pillow += %w[raqm jpeg2000 imagequant xcb avif].map { |f| "--config-settings=#{f}=disable" }
      system python, *pip, "--no-binary=pillow", *pillow, "pillow"
    end

    # PyVCF3 is the py3 fork of the pyvcf GATK pins, imported by gcnvkernel;
    # fastprogress is held back from releases that pull in uvicorn[standard],
    # whose Rust watchfiles extension breaks Homebrew's dylib relocation.
    system python, *pip, *from_source,
           "numpy", "scipy", "pandas", "scikit-learn", "matplotlib", "h5py",
           "pymc", "pytensor", "pytorch-lightning", "biopython", "tqdm", "dill",
           "fastprogress", "PyVCF3"

    # Installed on its own because the source build on Linux needs htslib's
    # configure options above.
    system python, *pip, *(OS.linux? ? ["--no-binary=pysam"] : []), "pysam"
    # gcnvkernel and scorevariants ship inside the release archive.
    system python, *pip, buildpath/"gatkPythonPackageArchive.zip"

    if OS.linux?
      # PyTorch's Linux wheels ship C++ test executables that are of no use in a
      # Python install and whose RPATH does not point at torch/lib, and vendored
      # libraries in torch.libs that reference each other with an empty RPATH.
      # Both resolve at run time but not to the static analysis `brew linkage`
      # performs, so drop the former and give the rest a usable RPATH.
      site = libexec/"venv/lib/python3.11/site-packages"
      rm_r(site/"torch/test") if (site/"torch/test").exist?
      patchelf = formula_opt_bin("patchelf")/"patchelf"
      { "torch.libs/*" => "$ORIGIN", "torch/bin/*" => "$ORIGIN/../lib" }.each do |glob, rpath|
        Dir[site/glob].each do |file|
          next if File.binread(file, 4) != "\x7fELF"

          system patchelf, "--set-rpath", rpath, file
        end
      end
    end

    # The R packages GATK's plotting and reporting scripts need. They build from
    # source against Homebrew's rolling R, so use the current CRAN: a dated
    # snapshot would pin sources too old to compile against a newer R C API.
    # install.packages does not fail on error, so verify the set afterwards.
    r_lib = libexec/"lib/R"
    r_lib.mkpath
    ENV["R_LIBS_SITE"] = r_lib
    system formula_opt_bin("r")/"Rscript", "-e",
           "pkgs <- c('data.table','dplyr','getopt','ggplot2','gplots'," \
           "'gsalib','optparse','backports'); " \
           "install.packages(pkgs, repos='https://cloud.r-project.org'); " \
           "stopifnot(all(pkgs %in% rownames(installed.packages())))"

    libexec.install "gatk-package-#{version}-local.jar",
                    "gatk-package-#{version}-spark.jar",
                    "gatk", "scripts/dataproc-cluster-ui"
    bash_completion.install "gatk-completion.sh"
    # The launcher is a Python script that locates the jars through
    # GATK_LOCAL_JAR/GATK_SPARK_JAR and shells out to `java`. It also spawns
    # `python` and `Rscript`, so front-load the venv and the R library.
    inreplace libexec/"gatk", "#!/usr/bin/env python", "#!#{libexec}/venv/bin/python"
    env = {
      GATK_LOCAL_JAR: libexec/"gatk-package-#{version}-local.jar",
      GATK_SPARK_JAR: libexec/"gatk-package-#{version}-spark.jar",
      PATH:           "#{libexec}/venv/bin:#{Language::Java.java_home("17")}/bin:#{formula_opt_bin("r")}:$PATH",
      R_LIBS_SITE:    r_lib,
    }
    (bin/"gatk").write_env_script libexec/"gatk", env
    (bin/"dataproc-cluster-ui").write_env_script libexec/"dataproc-cluster-ui", env
  end

  test do
    assert_match "The Genome Analysis Toolkit (GATK) v#{version}",
                 shell_output("#{bin}/gatk --version")

    (testpath/"ref.fasta").write <<~EOS
      >chr1
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTC
    EOS
    system bin/"gatk", "CreateSequenceDictionary", "-R", testpath/"ref.fasta"
    assert_match "SN:chr1\tLN:60", (testpath/"ref.dict").read

    (testpath/"reads.sam").write <<~EOS
      @HD\tVN:1.6\tSO:coordinate
      @SQ\tSN:chr1\tLN:60
      @RG\tID:rg1\tSM:sample1\tPL:illumina\tLB:lib1
      r1\t0\tchr1\t1\t60\t10M\t*\t0\t0\tAGCTTTTCAT\tIIIIIIIIII\tRG:Z:rg1
      r2\t0\tchr1\t5\t60\t10M\t*\t0\t0\tTTTCATTCTG\tIIIIIIIIII\tRG:Z:rg1
    EOS
    assert_match "Tool returned:\n2",
                 shell_output("#{bin}/gatk CountReads -I #{testpath}/reads.sam")

    # The Spark toolkit and the bundled Python and R environments are complete.
    assert_equal "2",
                 shell_output("#{bin}/gatk CountReadsSpark -I #{testpath}/reads.sam").strip
    system libexec/"venv/bin/python", "-c", "import gcnvkernel, torch, pymc"
    ENV["R_LIBS_SITE"] = libexec/"lib/R"
    system formula_opt_bin("r")/"Rscript", "-e", "library(gsalib); library(ggplot2)"
  end
end

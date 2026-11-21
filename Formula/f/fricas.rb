class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/releases/download/1.4.0/fricas-1.4.0-full.tar.bz2"
  sha256 "e113c721aaba673226d0806076a12ec82c07562c2954479443047d4264172514"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "19e8489980440724251e2239cc19851f6704ba045da5d1314ffd8205443458e0"
    sha256 cellar: :any, arm64_tahoe:       "84fc55f7ed80bc4d3f329518891a3cd7e11a275f02377e1743f10a22672889d1"
    sha256 cellar: :any, arm64_sequoia:     "9d00fe01185d295f387e5ef8b6f59253b684957ecd4cb496f2cadfc1537a5460"
    sha256 cellar: :any, arm64_linux:       "c57177f9de1c7722979869f56839708163a689f62a81abdd5e6f2391c4de8b94"
    sha256 cellar: :any, x86_64_linux:      "de8d79d1599836cf1a0d1364cbddb4c39ca93a0377ca9dca55d0b4bc50badc76"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  # jFriCAS, the Jupyter interface built into FriCAS since 1.4.0
  # (https://github.com/fricas/fricas/commit/7e01ccbaf6e9da6106d86a91aa31b3535597811f),
  # needs the Hunchentoot web server in the FriCAS image.  Build SBCL with
  # Hunchentoot as described in FriCAS's INSTALL.
  resource "hsbcl" do
    url "https://downloads.sourceforge.net/project/fricas/fricas/1.3.9/hsbcl-1.3.9.tar"
    sha256 "dc69541993ae3b14e1912e3160ba7a1e0f044be4af6ea46caa98dc6d65b54b6a"
  end

  def install
    # Build hsbcl with upstream's script, but save it as a core instead of
    # an executable: an SBCL executable cannot load another core, which
    # --enable-lisp-core needs ("more than one core file specified").
    # Make this core the default core of the sbcl used for the build.
    sbcl_home = buildpath/"sbcl_home"
    sbcl_home.install_symlink formula_opt_lib("sbcl")/"sbcl/contrib"
    resource("hsbcl").stage do
      inreplace "la.lisp", '"../hsbcl" :executable t', "\"#{sbcl_home}/sbcl.core\""
      system "./build_hsbcl"
    end
    (buildpath/"bin/sbcl").write_env_script formula_opt_libexec("sbcl")/"bin/sbcl", SBCL_HOME: sbcl_home
    ENV.prepend_path "PATH", buildpath/"bin"

    args = %w[
      --with-lisp=sbcl
      --enable-lisp-core
      --enable-gmp
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
    assert_match "Value = (:HUNCHENTOOT",
      pipe_output("#{bin}/fricas -nosman", ")lisp (member :hunchentoot *features*)")
  end
end

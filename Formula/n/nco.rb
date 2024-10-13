class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.8.tar.gz"
  sha256 "802676c8c22081e6eeed79b73ebe4cd6cac2edad49a712e17880b184d96daeeb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fbf08ec9f6f15c6b5d7d6c0130c580712fe22dbd3e64e040d45ff3e074ff0390"
    sha256 cellar: :any,                 arm64_sonoma:   "2eb52a8ec534eb2d6d4b6e6e0b1e0ba832005aea67216d571d5e7abd0dabc99b"
    sha256 cellar: :any,                 arm64_ventura:  "a6b9e7843387230dfe61049d75127b3ce7bd0ca3e82a1c5692505732ca103a21"
    sha256 cellar: :any,                 arm64_monterey: "6898877c4b5e0e745049d192c8475bdb5210700768518c42f3c95747628e6631"
    sha256 cellar: :any,                 sonoma:         "22156741c9df9fabd710e6637f41bcb459d55269b990f5b6be910b10fd2f469c"
    sha256 cellar: :any,                 ventura:        "53556d44c1479a324c38cce9b799001e4e4149da7c11550c2a05b9500e73bf5f"
    sha256 cellar: :any,                 monterey:       "c3bfc6357f79052a60b845c71590e23ed4ebb63ca3364afdb0b6265fb9280680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a61fac2263f598f7dc5354e4ffd17c17e0a3fdc737d56bd17890b6843b87d80d"
  end

  head do
    url "https://github.com/nco/nco.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openjdk" => :build # needed for antlr2
  depends_on "gettext"
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  uses_from_macos "flex" => :build

  resource "antlr2" do
    url "https://github.com/nco/antlr2/archive/refs/tags/antlr2-2.7.7-1.tar.gz"
    sha256 "d06e0ae7a0380c806321045d045ccacac92071f0f843aeef7bdf5841d330a989"
  end

  def install
    resource("antlr2").stage do
      system "./configure", "--prefix=#{buildpath}",
                            "--disable-debug",
                            "--disable-csharp"
      system "make"

      (buildpath/"libexec").install "antlr.jar"
      (buildpath/"include").install "lib/cpp/antlr"
      (buildpath/"lib").install "lib/cpp/src/libantlr.a"

      (buildpath/"bin/antlr").write <<~EOS
        #!/bin/sh
        exec "#{Formula["openjdk"].opt_bin}/java" -classpath "#{buildpath}/libexec/antlr.jar" antlr.Tool "$@"
      EOS

      chmod 0755, buildpath/"bin/antlr"
    end

    ENV.append "CPPFLAGS", "-I#{buildpath}/include"
    ENV.append "LDFLAGS", "-L#{buildpath}/lib"
    ENV.prepend_path "PATH", buildpath/"bin"
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    resource "homebrew-example_nc" do
      url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
      sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
    end

    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end

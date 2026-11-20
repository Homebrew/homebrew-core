class Fpm < Formula
  desc "Package manager and build system for Fortran"
  homepage "https://fpm.fortran-lang.org"
  url "https://github.com/fortran-lang/fpm/releases/download/v0.14.0/fpm-0.14.0.zip"
  sha256 "80d4caa2438ab68794685ad18e46605beef0d44beb4c7c3f34de7c14a4fde40e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2b91d3c3dd71bf82d76253ae7d1c8930bf920c574f367aacf067863f496afd51"
    sha256 cellar: :any, arm64_tahoe:       "a19641f1606992444c4f5c0813572397b184cbbe4cf6ffd0b67c02c54f80d5ee"
    sha256 cellar: :any, arm64_sequoia:     "792c5891be558b482bae3bb0db8909832eae25f8315513c8e2fed213c0a544b2"
    sha256 cellar: :any, arm64_linux:       "ac37ca985d6824a990a97dc861259b7a09e307c1b834854939540bf3a1e220ce"
    sha256 cellar: :any, x86_64_linux:      "d8a802c5e9a80570904005ae0849e8717e4e1c569021021bcfcdc94a25d13dcf"
  end

  depends_on "gcc" # for gfortran

  # Single-file source, used only to bootstrap the full build
  resource "bootstrap" do
    url "https://github.com/fortran-lang/fpm/releases/download/v0.14.0/fpm-0.14.0.F90"
    sha256 "a620bbb6dcb6f704badb63dd0d3b944fd437b3a8e2e4e3acd54ac23ea06bd81b"
  end

  # Dependencies pinned in fpm.toml
  resource "toml-f" do
    url "https://github.com/toml-f/toml-f/archive/d7b892b1d074b7cfc5d75c3e0eb36ebc1f7958c1.tar.gz"
    sha256 "df5ef916117742d69fdd708a36ee5c32283aa4b726a025a816b7d60ce41fd6ed"
  end

  resource "M_CLI2" do
    url "https://github.com/urbanjost/M_CLI2/archive/7264878cdb1baff7323cc48596d829ccfe7751b8.tar.gz"
    sha256 "5e5d4674c682a1dc31fe9e8347a91aab02084e9f65891e714f931a87b41fb64c"
  end

  resource "fortran-regex" do
    url "https://github.com/perazz/fortran-regex/archive/refs/tags/1.1.2.tar.gz"
    sha256 "9e3920201ec81ce3add258e2706b02a841f0cdd1817475ed39f77520d1df3959"
  end

  resource "jonquil" do
    url "https://github.com/toml-f/jonquil/archive/191b6d8e4007b2d15f428aed26fe9d9a32aca3ca.tar.gz"
    sha256 "bd183a1e2784f6038312d4775e290b0b725a0638fd42f78ea94fc543b85c949d"
  end

  resource "fortran-shlex" do
    url "https://github.com/perazz/fortran-shlex/archive/refs/tags/2.0.1.tar.gz"
    sha256 "660d1ca12ee8213d7c6061732a48d7fc29a13dd408afc334af26090ea842bfad"
  end

  deny_network_access!

  def install
    resource("bootstrap").stage do
      system "gfortran", "-o", buildpath/"fpm-bootstrap", "fpm-#{version}.F90"
    end

    # Point fpm.toml at the staged resources so the build does not fetch
    resources.each do |r|
      next if r.name == "bootstrap"

      r.stage(buildpath/"deps"/r.name)
      inreplace "fpm.toml",
                /^#{Regexp.escape(r.name)}\.git\s*=.*\n#{Regexp.escape(r.name)}\.(?:rev|tag)\s*=.*$/,
                "#{r.name}.path = \"deps/#{r.name}\""
    end

    system buildpath/"fpm-bootstrap", "install", "--features", "openmp", "--flag", "-g -fbacktrace -O3",
                                      "--prefix", prefix
  end

  test do
    assert_match "Parallel:    OpenMP", shell_output("#{bin}/fpm --version")
    system bin/"fpm", "new", "hello"
    assert_path_exists testpath/"hello"
  end
end

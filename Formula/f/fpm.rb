class Fpm < Formula
  desc "Package manager and build system for Fortran"
  homepage "https://fpm.fortran-lang.org"
  url "https://github.com/fortran-lang/fpm/releases/download/v0.14.0/fpm-0.14.0.F90"
  sha256 "a620bbb6dcb6f704badb63dd0d3b944fd437b3a8e2e4e3acd54ac23ea06bd81b"
  license "MIT"

  bottle do
    manifest_sha256 "0251cd4dfba4573b01402e76211debc6487cf7858f5eb8c52bf9015359f901b1"
    sha256 cellar: :any, arm64_golden_gate: "2b91d3c3dd71bf82d76253ae7d1c8930bf920c574f367aacf067863f496afd51"
    sha256 cellar: :any, arm64_tahoe:       "a19641f1606992444c4f5c0813572397b184cbbe4cf6ffd0b67c02c54f80d5ee"
    sha256 cellar: :any, arm64_sequoia:     "792c5891be558b482bae3bb0db8909832eae25f8315513c8e2fed213c0a544b2"
    sha256 cellar: :any, arm64_linux:       "ac37ca985d6824a990a97dc861259b7a09e307c1b834854939540bf3a1e220ce"
    sha256 cellar: :any, x86_64_linux:      "d8a802c5e9a80570904005ae0849e8717e4e1c569021021bcfcdc94a25d13dcf"
  end

  depends_on "gcc" # for gfortran

  def install
    mkdir_p "build/bootstrap"
    system "gfortran", "-J", "build/bootstrap", "-o", "build/bootstrap/fpm", "fpm-#{version}.F90"
    bin.install "build/bootstrap/fpm"
  end

  test do
    system bin/"fpm", "new", "hello"
    assert_path_exists testpath/"hello"
  end
end

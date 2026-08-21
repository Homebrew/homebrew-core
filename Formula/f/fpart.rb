class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://www.fpart.org/"
  url "https://github.com/martymac/fpart/archive/refs/tags/fpart-1.7.1.tar.gz"
  sha256 "512a82320cf5418ed70416b96cd49aa51a5ae418e96482144683cad6609add2e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a7b6bfbc2279332153d51d52841192833f3ed34ef8c596d27af275231a5b072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35796778e1a61ef685e0bc42255ee66de6118206dffd63e2a81c1834e37acabb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288b3d14e8e04b83a5be53ddbe77c5702412bd6a6e6bb449c1443883ed323f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f801675689144e579ccca49232458b1e242b8719fab4120deea0b99311ceaa9"
    sha256 cellar: :any,                 arm64_linux:   "96302cefa0fcbeea32aaa400cf7109a7040cac8ddc15f2eaf9f84407eff063cb"
    sha256 cellar: :any,                 x86_64_linux:  "f8ddc70935f0c39319d88eac68e6c577cae2d74b2beee43e0bf6606dabc2b7e4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    assert_path_exists testpath/"mypart.1"
    assert_path_exists testpath/"mypart.2"
    refute_path_exists testpath/"mypart.0"
    refute_path_exists testpath/"mypart.3"
  end
end

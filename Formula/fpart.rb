class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/fpart-1.4.0.tar.gz"
  sha256 "da4cd97365a2ebb3d0ee7e634c022eb21321ee5b6ab213d796fcbb01f28d9759"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9953748a9eb170c83a20c8c0706306f27ff4a89ba4302da1115dab7e6ca14082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a63f24931f43d9d9c887f807df5a811c0c5ab0242c7187ca37040358fda1d7"
    sha256 cellar: :any_skip_relocation, monterey:       "1e01ae4aac80a3a913b1e7e9c97e16567ab320d82cb7856b610db91d597be815"
    sha256 cellar: :any_skip_relocation, big_sur:        "741db79f38bc38921cd62b0fca57195acb793a50e64586ec68a2a6c8cb596aa0"
    sha256 cellar: :any_skip_relocation, catalina:       "0b987e9b4eb542e14cd1d894a318f94d0e9d08affa2c694713d909d7d6bd3dc7"
    sha256 cellar: :any_skip_relocation, mojave:         "b0e2dfd4356d31684bd79f8307217af16cb779448a30c9ad24114673c500e997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13304c2e16a01c67c6455cc115e8a486c945deccaf430724e87a47c15bee3bd1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    (testpath/"mypart.0").exist?
    (testpath/"mypart.1").exist?
    !(testpath/"mypart.2").exist?
  end
end

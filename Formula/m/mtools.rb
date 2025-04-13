class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.48.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.48.tar.gz"
  sha256 "88f273c6629ad5464482e98a9980727f585eead8736c50717c95e36f05ca05dc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9e24a85323344ba64d5e22d8af0e392c70b05b583476d6cf8f7d31c963dea2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b47985d9ea303292ffbfee4de611e4f30cf1df07006af728862dfd00cd81dd26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac530692ed65ed59fee5bb71bc60343581860cdac2c9b6c7da35b57fae0cff60"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d459e925ce754b2ad4bd21743843159bed88fc84700c8d72ac8b36a8a713261"
    sha256 cellar: :any_skip_relocation, ventura:       "f1d8831b6a65b99b20e1ff6864dff373d8bf921e782f44b0acfe2f787a206f93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d5a2e8c4c343781210aefe1bcac205a4dbb490bf99400d4ccaaf8a7eb49073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8163f99ee69a63637c3f2a70927e7f16a8f6a75d2cece8f19aa6f2bf059beb64"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end

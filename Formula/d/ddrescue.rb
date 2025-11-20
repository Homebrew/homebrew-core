class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftpmirror.gnu.org/gnu/ddrescue/ddrescue-1.29.1.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.29.1.tar.lz"
  sha256 "ddd7d45df026807835a2ec6ab9c365df2ef19e8de1a50ffe6886cd391e04dd75"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "729d6d7adbd0125a8639834b89a066e3a76f75005db9ef984f81fef433b8e797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e476b59ccb2c4e24c8318a351ebb15663bfde3c084278d0adf4327e249de30b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341eba2a95b1cf48b8c5d07411ebfdeaa180a6b103eb7e52e0f76a6120c4ce5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75a1da03c8dc5b41d6d2e7157bc938c287d62a50334a369483da7d221c0755ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "2277f04febdcaacfcaa8d3bbbe08ea89be1f9be6b6e94bbe927e035c634f6e6c"
    sha256 cellar: :any_skip_relocation, ventura:       "f87510cf76af9fd9ceb1a54ab75c2431f165c231f58b86906ca157a4ce25cd3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a833745d143f8cdfefb829e0ab7eff79790390e7d02f3eb05a69d00094b9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e07569c6bae809a4554d8054e5cf0e110cceb71954e641d1bfc3a4d1b455bed"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", File::NULL
  end
end

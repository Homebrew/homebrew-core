class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.40.0/mk-configure-0.40.0.tar.gz"
  sha256 "2a422f78752d25f37800cdfe5e96f1d081066837feefb8c8109db4e1daf51d4d"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e4ed19f77dc079bbb5a81a8d7d68c938dae9b24249eee52100c4f0878fe551b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991206600e83a6063a6518b312d991f8bf8390defd941c41af274354e5fe24f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a6000f58e84b8f47257cbaed106b59f9a908a5cc0897a88eeaf81e779b6e176"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e4df5fafb64a8b2b6c58d5f10f97316016731381ba859ec61fe79222e3404ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "38eff0dd90436b640ff6ddc3cc0f2f208d5a1a5f0f609c873c8a093fe90cc2be"
    sha256 cellar: :any_skip_relocation, ventura:       "6981ba14741216c3651d168e0f29810904547ad38df976ca0cd6305c7f3a29a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a75eda4ef70758b92fedce279ab4c2dbb0c83a2b050c45a419e9e12e005102c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434d05bf1acf22ab6f0f9f3fda53b07228fdadac453d2c6fbf7ba38e5a32d637"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system bin/"mkcmake", "-V", "MAKE_VERSION", "-f", File::NULL
  end
end

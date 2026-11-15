class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.40.3/mk-configure-0.40.3.tar.gz"
  sha256 "3b70b7ffe817a386b13bca7f685fb068d7fd7925a51c9710a8557487d5f1c732"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccb10984762f775d30bfad9339f1923cca187136f2995405b43560b1b6d4a900"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7fba1636b38bcab13a6ee3dfcd83da99ed0014590213212c145471bd2a6f88b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e3d19239825c9d7a257cb30b9f676b511393edb44a00e992be8f85d668cd9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb04b35f3c38771a85f84db5eaf13b75a5b340a472d09ebbe0250f20d158c49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "71f07607193d9718bb7186298ddd29b43df95060529a38efb5883b3d9b1a8f6f"
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

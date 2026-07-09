class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.55.0.tar.xz"
  sha256 "457fdb04dc8728e007d4688695e6912e6f680727920f2a40bf11eacc17505357"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "af1df5e563c6acfde0ae8bcbf963e55dcc7d929af61b910bde1b1e444d21c177"
    sha256 cellar: :any, arm64_sequoia: "64bc742211afe645d8140ee8d91cb918e3fe5e1183e418bd19c80dc0a270c573"
    sha256 cellar: :any, arm64_sonoma:  "968f847ff4f8ec19d14c16c2ce2fed0e4c181eac670a6513bff88c0ccd403d69"
    sha256 cellar: :any, sonoma:        "0c41becc1bf285597eee3976d3fffefc81351cbb87296768fff353825f9e3866"
    sha256 cellar: :any, arm64_linux:   "7618504e71dbed0967c5f86aa5bbeeb91cf09ce56c677b31f46b988e087eaa8c"
    sha256 cellar: :any, x86_64_linux:  "648a11486967539af6109e28582781c06fdab19c0acbc53d73c97dda077d17e5"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libsecret"

  on_macos do
    depends_on "gettext"
  end

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS

    output = <<~EOS
      username=Homebrew
      password=123
    EOS

    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end

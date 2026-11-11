class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.56.1.tar.xz"
  sha256 "f0b0bf89264b9bd2e1c640363e7529643989da76281600473c50745cd34a607f"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "38a9fb547929058debaa58cf8d151a71a399ef76cb3ecb3cf9e23ef6a7d64a09"
    sha256 cellar: :any, arm64_tahoe:       "b2f8b9477f2d365e2535c4dd94ec267935b39a417b10d83a479fcdcdd52e776e"
    sha256 cellar: :any, arm64_sequoia:     "8f6bdbc70aa22524377ab9ebe001a3f5165b7747c77ead4114cee7823e3a84db"
    sha256 cellar: :any, arm64_linux:       "f968f642f48e341ffb892b56afb60bfcbac6ad03cb69fd6a8118063f7aee9cab"
    sha256 cellar: :any, x86_64_linux:      "f4a177047021fc59fe11c51cbf2650e0e2f7a4f34eec9713d5b6af01bf1b9728"
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

class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/2.5/cvs-fast-export-2.5.tar.bz2"
  sha256 "84eefa84a0f71b076147522c59dbecb64a6b691742c065cec354c39f944cfeda"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2f1a13e0bc9a410c2132761d488cd7ba8eae911eb8fa7587d0a793d32aaf997"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2f1a13e0bc9a410c2132761d488cd7ba8eae911eb8fa7587d0a793d32aaf997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2f1a13e0bc9a410c2132761d488cd7ba8eae911eb8fa7587d0a793d32aaf997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b2f1a13e0bc9a410c2132761d488cd7ba8eae911eb8fa7587d0a793d32aaf997"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "620a36c2bda5127ee882da70a6c121a9890abadf2924cf5ddb5e7d3b80de8d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "913712064b367153a2a85b3fb56d508f15fb592aaadb89780cf869541b1be067"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "cvs" => :test

  uses_from_macos "python"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "man"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    man1.install buildpath.glob("*.1")
    bin.install "cvsconvert", "cvssync"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), *bin.children
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "cvs", "-d", cvsroot, "init"

    test_content = "John Barleycorn"

    mkdir "cvsexample" do
      (testpath/"cvsexample/testfile").write(test_content)
      ENV["CVSROOT"] = cvsroot
      system "cvs", "import", "-m", "example import", "cvsexample", "homebrew", "start"
    end

    assert_match test_content, shell_output("find #{testpath}/cvsroot | #{bin}/cvs-fast-export")
  end
end

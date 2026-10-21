class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/2.6/cvs-fast-export-2.6.tar.bz2"
  sha256 "54b93785d4d107d41b368e0d190678a17a03891e19b544481d9980cd113c6eef"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b39729c3f12f7097903a9c0ee82d795cf9023d75b0c270c7c04345d0a1adb04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b39729c3f12f7097903a9c0ee82d795cf9023d75b0c270c7c04345d0a1adb04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b39729c3f12f7097903a9c0ee82d795cf9023d75b0c270c7c04345d0a1adb04"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "783b134239039debbfebc95f54e35dd2ebbf7a7433d9111e8685115c037af56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3b985cf99590771f6595a0123c47db41dc9b1c74a044de9bf01edfeeced83c30"
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

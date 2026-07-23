class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/2.3/cvs-fast-export-2.3.tar.bz2"
  sha256 "0559690cdf5d6da3fcd1957697b0b73ff3857f29df27ab7ed32f9e855d21ddc1"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38155b919b59eca4b641ea04db7d0a91f99f77f1b7e1b916351dc553f1aaf71a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38155b919b59eca4b641ea04db7d0a91f99f77f1b7e1b916351dc553f1aaf71a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38155b919b59eca4b641ea04db7d0a91f99f77f1b7e1b916351dc553f1aaf71a"
    sha256 cellar: :any_skip_relocation, sonoma:        "919151cd27299bc8c9bc6863cc6afb75fb2c6199b13cc4e3e4ccb5aaafb835a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d15a192efd4f10816e1ead37775cbaa351ee109c040d77afb9a788cb8c345ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fe7b73fa4870f0da2a002fb5c4fdc9da1edc7a48b65adb0c52fc6351cf656ab"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "cvs" => :test

  uses_from_macos "python"

  def install
    system "make", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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

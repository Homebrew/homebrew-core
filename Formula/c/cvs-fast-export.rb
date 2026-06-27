class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/2.2/cvs-fast-export-2.2.tar.bz2"
  sha256 "b37fc8d6474d5e70c0002d73de544d5fec67521d97879987224a4c894eb17d96"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54275260d64b042a8ae618d043602da7ce040c350757adf10e0575a666b43578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54275260d64b042a8ae618d043602da7ce040c350757adf10e0575a666b43578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54275260d64b042a8ae618d043602da7ce040c350757adf10e0575a666b43578"
    sha256 cellar: :any_skip_relocation, sonoma:        "9474a5b80461d2c9b051f4f721cc6e283272f01f1c982e7e7e6e9ae49ba121ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920a78fbc6fa8f310c9923ec9f3cb0acb4b7724ca90bd249580d94759c0c4f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cccb7539809c28cd0b369f2ef3d2495d965bd2f054826fb4d6ee88f839bd3d9"
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

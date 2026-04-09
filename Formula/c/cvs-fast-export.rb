class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/2.0/cvs-fast-export-2.0.tar.bz2"
  sha256 "9eb3d54d4631c5447b6f8c12ca8c08a32ee4255768c90dea66dbfef5b8a6a624"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f402cec3473616edec6bee65fb940a45e06e76151bce1856927c3f37787c795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f402cec3473616edec6bee65fb940a45e06e76151bce1856927c3f37787c795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f402cec3473616edec6bee65fb940a45e06e76151bce1856927c3f37787c795"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe8f9e74e688482a9cf911a0b211a194c9e2498db827dedd4e714903f7235056"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c304514ded6cd90284d11f0d5c7f6a0823a3996096bafaddc3800ece3c0a0638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f89215bad4fdb70df12de12150ee211910ab6ccc931c09d74ce35f22d4043a"
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

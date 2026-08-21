class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/2.4/cvs-fast-export-2.4.tar.bz2"
  sha256 "6ca32d04ebce96a4e0a00d391af53a1f5c670bfc2bc1e2b06a89bce2c5223b39"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51f93ab4538297329f06cd29df096e82f99da9e0ebf1e015c39a4f43a8e6283d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f93ab4538297329f06cd29df096e82f99da9e0ebf1e015c39a4f43a8e6283d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51f93ab4538297329f06cd29df096e82f99da9e0ebf1e015c39a4f43a8e6283d"
    sha256 cellar: :any_skip_relocation, sonoma:        "463565950ba70ded0f236c4566b700cdd2e84d87944b6b92ac500c9cf8f462e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b64a99f9bfd2196f7a611fcaba4f7ac2d7f329b6ca284c1c97ff3ff5616763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9331d9d4216cc28b7b3c9d36f9c8fdd5fe8045971680b53851f9c5d5a54f86"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "cvs" => :test

  uses_from_macos "python"

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

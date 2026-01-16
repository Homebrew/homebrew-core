class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/1.68/cvs-fast-export-1.68.tar.bz2"
  sha256 "7007b6fde9e8d622e889f332012ac074a406d09189faf6c0c7bf24547fd55734"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a588033b25137b05eb8ae709e17fb689d36d7951138960f11cba6f3a122cfa37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be684c4690ae50c5b8d35704827eee375b29fa7aacd6c1d3e16a96e1e73d552f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c2463a58adaea270f14076290f5fad917c46438e4a08f68583cfc1e4c493315"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9a118a01f3633866024f0ccf210ed45b1bd3b2d08b9f56ed072abdcb11c1bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f8a83d4bb3915ac036b726f5e5b68a43db5874c076afe363b3fc1ef6e194d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a5bca34f0a70c12aff21f7ec5f3188f7703036d40e150b76c6c91bd4de92fd"
  end

  depends_on "asciidoctor" => :build
  depends_on "bison" => :build
  depends_on "cvs" => :test

  uses_from_macos "flex" => :build
  uses_from_macos "python"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "install", "prefix=#{prefix}"
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

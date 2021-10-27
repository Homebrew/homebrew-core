class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      tag:      "v2.0.1",
      revision: "b1ec32e02fe539480dc03e3bf381c20066e7c6cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a31c1e7e161708091568c9585c21f378bb754dec41a909e52758fe968698fe07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29c6f41dc0d4cfb59a80b55f84b2329ba00d75576cf1a95c050dd372044e30f5"
    sha256 cellar: :any_skip_relocation, monterey:       "6e8560823efcfda202c24556d32044d6cb06d0ae06cde86dd92bb4b675b50d33"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec0e280e3b7f68c5f0c7415aab6bf202f18080ff87750584a446be1a5636fa97"
    sha256 cellar: :any_skip_relocation, catalina:       "ec0e280e3b7f68c5f0c7415aab6bf202f18080ff87750584a446be1a5636fa97"
    sha256 cellar: :any_skip_relocation, mojave:         "ec0e280e3b7f68c5f0c7415aab6bf202f18080ff87750584a446be1a5636fa97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b39e17cacacb31eecfc3412dd251b536c717384c4634fe252691a1e0f305706"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    system bin/"go-md2man", "-in=go-md2man.1.md", "-out=go-md2man.1"
    man1.install "go-md2man.1"
  end

  test do
    assert_includes pipe_output(bin/"go-md2man", "# manpage\nand a half\n"),
                    ".TH manpage\n.PP\nand a half\n"
  end
end

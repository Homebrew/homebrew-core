class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/md2pdf"
  url "https://github.com/solworktech/md2pdf/archive/refs/tags/v2.2.18.tar.gz"
  sha256 "c231d18742d9b0618bd1feaf1f3ab8864173a838b1847d9dcba6018fe5888f10"
  license "MIT"
  head "https://github.com/solworktech/md2pdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ba1a4bd35ea147d4af6dfd4e77c9c432f89d323a869e69946e81b065980d260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f31a7fd7fc59f484e62023b815331c624d0caac12e8573e3dce5a72a53d9f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f31a7fd7fc59f484e62023b815331c624d0caac12e8573e3dce5a72a53d9f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3f31a7fd7fc59f484e62023b815331c624d0caac12e8573e3dce5a72a53d9f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1067ffc7b46773d8b98334e7ce11bc5e654f06ec4d891e545856191d5d0ca597"
    sha256 cellar: :any_skip_relocation, ventura:       "1067ffc7b46773d8b98334e7ce11bc5e654f06ec4d891e545856191d5d0ca597"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cc40647488a0594fb91fb6f0db586a5134a8c42f178ce4e22b0829f0aa68dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "210dde51799b9cd2fa6037e4f1be39042346be5ea96a1a4cceef8bfb8df00180"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/md2pdf"
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
      This is a test markdown file.
    MARKDOWN

    system bin/"md2pdf", "-i", "test.md", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end

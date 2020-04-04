class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.7.tar.gz"
  sha256 "b450d6f1c07624b4c31fd9bc7cb4390ca53e2c318136c62a86aaeea222437919"

  bottle do
    cellar :any_skip_relocation
    sha256 "584fed87972680f93e915df6c46c782a09e4ca13805a7d9eb0d7fc4d3257cad0" => :catalina
    sha256 "1385865673f05807fa7ce4b038a89cc3f575092923f629e0c1655539dca11ba6" => :mojave
    sha256 "500a6bd48e49190b200029ddead6b4eda9a0d311fd7de412a96e3be256326c0a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end

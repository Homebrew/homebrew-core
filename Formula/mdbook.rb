class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.30.tar.gz"
  sha256 "9df217a6a4c22d4b0fef0d13e04b1a9ae896a0c1084af36b93d032c9fa2c4148"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "438f33d83ac8c00ccf93396ac0dd7455d4c92e87a39f731a374e402f0f176bb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "991e1e76ea3bcca869dc9acad181fba2ffefead2cf31790f8af7063b5cdf4cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7ee4654aab96713612982c7983cb7aec35f4f57960b4b7599419fd76ad8e37e"
    sha256 cellar: :any_skip_relocation, ventura:        "4acc4a12c1c41ecb4093cee4bff05dba3c341b74feb3834f3090ad6dde24f292"
    sha256 cellar: :any_skip_relocation, monterey:       "8f1c105249dcd3a789b859ce1c385bc84d1a742399717319ac7724361d37fd52"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e2f19a55baeb5999705e6923fbf3f36f25ae05209c4eeaa663a90a037735855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f12d3621d0272caa81673803184885b625e3b6cf5d904ab12f723fe3e3a68be"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end

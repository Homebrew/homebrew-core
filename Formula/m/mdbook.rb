class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.51.tar.gz"
  sha256 "de5ee916157784e32451b81de01cc4c669b73e651e2db00c7b1809254dbb6259"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0563b8a5f71ccf3c93acaf03c9fbfefb6c3e226a61dea703eb2f881b27d13c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14e47abf7e79e110311559ce6943e474efb784fe2683f89625a3c5f03ba7d6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaf79004c82faeff5bd0106a57824a504b383329fe560371c3044d3d8bb55b94"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e81a0c95019ab5e7d8622096c8c80f3dee195494ce93f27d7c620788a110eb4"
    sha256 cellar: :any_skip_relocation, ventura:       "fca23c03102abdaee256eeb940217c39ce5dbb099f60d93f1c6f35db4c1858b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad5d2b6f98c40e61b9560812267bf529bdbf7c5772d3e7aac7836fd92cb206b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f2a78fcd3296919320b97ae09b5655f42e2d19e1b5990cc5515329d27e8fef9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end

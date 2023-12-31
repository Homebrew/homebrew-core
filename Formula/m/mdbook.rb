class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.36.tar.gz"
  sha256 "dd47214172ecf95e1b2cbcbebb8428d0b029e0de5dce74204b3c3a91f26223a1"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad2369a8313b13afacca721208899ffa33be89364cb0138c47502b4699bccba9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09f5c08e3758e768d1dba879f5ef59a9a800bd0f81ff0dfc23e907d683394c05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e48bd313234baa67f3c8a46919cd499ca783aff8c2ae8103afe6c9419fcd8adb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e6ae64daa4d94670214deba17c5b0df45306430711318934fa11df05f563e6b"
    sha256 cellar: :any_skip_relocation, ventura:        "0eebe5ce5661128f522903cbdf9ccb8d4eb78ba5076a655600645a58b99db04e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d18289c2b6354eedc453ad3cbdb15dd581d2054c2b829d671c533b50df3c189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "841a8ebbf04b130910e1300ce4715eab72de475428424e15888daa467e0d87ae"
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

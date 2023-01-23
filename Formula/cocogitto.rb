class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.3.1.tar.gz"
  sha256 "ac6847ce55ba284184d0792afb53c6579da415600bc1b01c180dd87ad34597d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87685c70c732a72fa1518e48e28d12422ecc75ce1d873fc64df7ff9c333f2825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f140f316b9b061b7e118e32375b7f82304a5bda53a9c27a478163c92ed37d0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5937cb632d2d8c8efced6db54d390da6ed0f9b813cefc00b7361a64f4da3684a"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c0d5bc34f8d9587f5913e7f795245814c4730ad21950236e92873bc1161137"
    sha256 cellar: :any_skip_relocation, monterey:       "bd2f0c71e87edaa4b9f00c09f386bf4535bf1090cc5833f035167cd839ed0084"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5399375c3e75feaf0f6a8adc7f497ee1384130b69c0dc9fb94d421e0f3df554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb11438ddcb1deb1a30aa764ddf37f47fb6da6b3661ef94d7dffedf39854baf2"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip
  end
end

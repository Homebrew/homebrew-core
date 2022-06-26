class Bvm < Formula
  desc "Version manager for all binaries"
  homepage "https://github.com/bvm/bvm"
  url "https://github.com/bvm/bvm/archive/0.4.2.tar.gz"
  sha256 "d60c2e49bdac1facd9c17e21e3dac52767ead2fd50b1a94f484fb6d180b0acbd"
  license "MIT"
  head "https://github.com/bvm/bvm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a284f10dc418073f3f9920acd946b6d494e9d81c6c9628532d352546ff47c683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e05342a9aaa52b60891218158811a9c6848a4f7e37919e9029e022db54226490"
    sha256 cellar: :any_skip_relocation, monterey:       "03fa1710f7665d0910ee7a501572de68fcd5977b98ed265d456674e7aedf5d1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0de6d3a5c96bd9131e5d075a44d727afa4ccdf7ad7f91cbdef65edf7f42a2149"
    sha256 cellar: :any_skip_relocation, catalina:       "03feaea85d097ba5b2e6248f001b49859f808b263d0184023c03946bc0e9b198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dc4ab8b9c8addd472add6233b07154a7b10886accfc76854637c980bdc28c4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    bin.install_symlink "bvm-bin" => "bvm"
  end

  test do
    ENV["BVM_INSTALL_DIR"] = testpath

    system bin/"bvm", "init"
    assert_predicate testpath/"bvm.json", :exist?

    system bin/"bvm", "install", "https://bvm.land/deno/1.3.2.json"
    assert_predicate testpath/".bvm/binaries/denoland/deno/1.3.2/bin/deno", :exist?

    assert_match version.to_s, shell_output("#{bin}/bvm --version")
  end
end

class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "845688b6ed7621aab08e55e17eee36875eb77343a720377787c7f2a5f3ca2de6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42979c9e79275e6e32b5fd54b0893b9da74c5ef1a6caa0adbf79517d8c60da72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0464abad858ebb1ecbec8b8a9a97d1fde2ec1bed209b90b1c7f8f980d19c59a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "225f9305709fa9e6641ea63fab925c10038a49d98a4a905fa115a6faa1179dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff79cde9f49924cee57b1e436a6c46121e373f358c7c0883fedbd78d3e405a19"
    sha256 cellar: :any_skip_relocation, ventura:        "774cb1f345f1b1a8efa2564390e45dca9bd867d8edab8de413bc5128ab1bd303"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6e0dac601783253002befd72f108be2f16ec3344d6211c31326b7f140c46bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d10fe45f2bcde72a3c17c2f5e9917e5bdc60e1a5b90483ab619d5980d412989"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end

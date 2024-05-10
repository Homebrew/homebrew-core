class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "b1ae2cb61b60014736855e2af35032deeed74fbf6375be4b862daeb0d98ccb24"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b969551fe5fc15a042febd043c7115aeeebfdebcdd404db38c929d1ef0aa015d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98b34ac3a1609ecdb1202a2262620715df02b515811234e6178c8a2320c5f74a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ab4c788ab43ba1445a05e0a2a2deae60b4a74382ac8692186a801a6eac1e196"
    sha256 cellar: :any_skip_relocation, sonoma:         "b83883b15f77aa438293f48e1d57cabe4d59baec7e8e6d7112a4049518a46184"
    sha256 cellar: :any_skip_relocation, ventura:        "b1699b3c1e77e6aea105bb3ed2b9bd05ea10bf7f584fc635d2094b4fe3aede17"
    sha256 cellar: :any_skip_relocation, monterey:       "97ea137ed7222d598f2662b0045a1a7b648d9e0722c374628fd73f22213168c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad1eb4070b78993623bc166bbd4382b72794ef2fe1b3a6c2b2de287c1a0dba1e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end

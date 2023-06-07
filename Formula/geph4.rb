class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.8.5.tar.gz"
  sha256 "478d4d028c2306931691e2dd4943fec05b1776de7c5fa7ea22b74318f197cdef"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4deeb72d005c042b1a17e7603feceee8a5f90327009b375d49f777ac947de2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b8d913524acdf36fb55e65b4f0df16ea14e2a5059b994bf85e925bfff7c0082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f7833234aadda7730cc9777ede0d3c67d6393366a54167c40f3ed03f295897"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e1277fbfedd1dee8380bce8549e3e2cbf4dcd3a5513c5c7c9edb818b70e9d5"
    sha256 cellar: :any_skip_relocation, monterey:       "becee9500eb8206c0a0fab24a2125c4bed6f6e806ee019f045c28760be8b8a1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8bd6a68536b4e249a3c00936c245d47633eb4ec18d9b74e2a4747b64ed733ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "479fa1ac766a730180559eb52e82380faa1378a11bed1a8509dfe0e65cc9265a"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end

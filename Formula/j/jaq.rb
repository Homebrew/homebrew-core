class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "26a4dd9b74a98f2c94283d3d0c8ec559ab2139a051997e0aa099cec5585e06bb"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c5aa2da7436ff035b2e2e570f80f7e030b0c89cc1d8df02e43b229d51d3e17b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab293d6ffe8d8687b098bec50fbe80a171bec48b72930cc73873d6a925dacdc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c291d54f609c04f0bfa60951a39bd9b68d6f147ff93d9709f9d12ce9265ef8"
    sha256 cellar: :any_skip_relocation, sonoma:         "754abc3350edcf2d38d77584350756e87954e087a080a826915b01490cf1c572"
    sha256 cellar: :any_skip_relocation, ventura:        "d571ad5c5390d537d66f70af57ffef31e38f2877a3b0f259b723acc4757f5b7c"
    sha256 cellar: :any_skip_relocation, monterey:       "1d123c0e29a497f1696a839b28e77778ef16a09c17082cd40982f79b704ef2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201d733099262a2b5886dd843fc3db06375e5a774cfa05269f445fa8aea71f93"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end

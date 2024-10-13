class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "64b3431970cd4c27f3c4e665913218f44a0f44be7e22401eea34d52d8f3745a9"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "11506820284464b135e23f1afabaf86c7d45c75abf3faa1c4c9e6902da271f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b79ff4943b0d75a4edcd19838137462804f5dbeb67cf6cb5b3526b919212415"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4692800435b5234283a7517ed44d2043dad4bf1b0994f635c91bc37dfb2fd9f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fedc4822b9f5f7b34507af91bc2a14b387022aa45edf6b4e67e1e2c4c84f3d75"
    sha256 cellar: :any_skip_relocation, sonoma:         "508af1b51de651dbbc5e111f2066b21b80d6ab2fcfb8c14031acd498b1aab0ec"
    sha256 cellar: :any_skip_relocation, ventura:        "ae446061a59112b2c0c0616f9172147fabf52339e210205ed7af763a94c23fc2"
    sha256 cellar: :any_skip_relocation, monterey:       "69342098cd7b986aea53586eeb883b5b91dea4de6c8ab38f65ef496d78e7dd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44c6fac1358c69d3c045b4fb8c1f770881da2671b17962a1cc6f167db76eb91"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end

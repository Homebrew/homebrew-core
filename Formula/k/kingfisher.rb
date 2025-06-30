class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "51edc92730c7354b1c157ef4aef05d88c21251b9391f754ad66affefbb269a7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed204dc437df1e25fe763edbf1a5436e8e6f0452fd76694ee145781c4a5d4883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97293b37b1581cd122c7b80fe55f5d9941cff56ba37d30f0546524ab677bbba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6e8640f7887b307c2281418a7ae46cd5b3e43302ee1509af7921bab24d506ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "980cb8c4a85918d2a622cbfdb472ac23673af3c3540f7abb6c3141916c1e038c"
    sha256 cellar: :any_skip_relocation, ventura:       "5ae8ae3bd760dd2baadd6363a46ca62a4c0c666c6918e84926d4cc0c57d2e6c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4f340a24879a0b46e73a1fa1bc0e2d0113d827d08514d843d4973e9a5428cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad57d936f21b7c83a3e1b76d5be46fc1bd7d41419851591a2b975602bd1ad410"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kingfisher --version")

    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end

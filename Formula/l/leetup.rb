class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/v1.2.3.tar.gz"
  sha256 "b3f57dd96d2b823afe99e5c990ee09e90e19627dce722aa9407f23b516e7342d"
  license "MIT"
  head "https://github.com/dragfire/leetup.git", branch: "master"

  # This repository also contains tags with a trailing letter (e.g., `0.1.5-d`)
  # but it's unclear whether these are stable. If this situation clears up in
  # the future, we may need to modify this to use a regex that also captures
  # the trailing text (i.e., `/^v?(\d+(?:\.\d+)+(?:[._-][a-z])?)$/i`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07cfb7d4b4a2fbe494ac65867ff6222652fbc0de12a23d42d1f845e3509b9dcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8690bcccd7f34ec5194cb1e0b2edfd2ae7c5ac2089d9b5d98147dc44f16ab98b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99ae182820e17a22ac82cd624bbac1a3dac13480efb83e33fc0b7820cb6da9bb"
    sha256 cellar: :any_skip_relocation, ventura:        "006111464d21c9e9b10fc29504ad866d5e3474faa83b4b3a4a753e3f9520a3f8"
    sha256 cellar: :any_skip_relocation, monterey:       "feebe93d72f4c2bc1174ed89b83081d8f74910816abc2d2fe3119c9b8c7ae5a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb6d2ddb675d8451caa7815f6634c7260390bb1ef50799fb811378273200fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8ab05fec8617edbbf41c8cada5fcd1ca51877a632b2430c81f53eea343a776"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Easy", shell_output("#{bin}/leetup list 'Two Sum'")
  end
end

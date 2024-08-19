class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "56a170304ab281439a71e541c4db878848c3a891078ae3c2dcc84017cd0306b4"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b76925bd68d73812fa50dcf9768dbc08f9cdbcad5fd1d54a4824551f9924cb77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be21cbd78b04ac291aba99b4044c644c3b25462acfd581d7d8a321f98e13db1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "023f0243f9f181da44311a19d4371156fd4a2fdde891f2e9f3d74b4727bc63da"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e47c4ff6ae6abf8e814b0dab30e80a1e26f1b71ce0bc70709c802b1cbdf44d0"
    sha256 cellar: :any_skip_relocation, ventura:        "5f03d2930e7c35f46853990183cb6ba49ecc666da19c5519b90e555a3fbd1021"
    sha256 cellar: :any_skip_relocation, monterey:       "24f90f9dd3b446a33594a728d7e74ed0f07b1ea32b14ce8d740a121354fc4a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da3ea9b80b434ff1097927a2f4701b8cff8c327e111972d9e990ab0fc8a1422"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end

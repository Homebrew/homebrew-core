class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "224081a677a02acd9f972885e824a98fa3843f5b778b28400ad5af97752f6127"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "504d89f4004b37c19fdbffd786c99982451c54d9112357f1f8bab27d85336ffc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30de486e778435421c94b5596ecf1fd009851f484b6147c4ceaa01c5bbc72506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95d65ae8a17147eae7eca5b839ec16a4dbcee2d0a6bb4495ebb20dc721075b65"
    sha256 cellar: :any_skip_relocation, sonoma:        "4733aee6c9507e4100bbdb83ab062e421893ac53538dde7809d17ff619d3bd99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c561bcdf8ad5c79b0be0dcc46ffcc3aae48fe5ac587530c9411de6ba1c6ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e590e196d8cda53779aa9e9dd0aeb8eab19bfa1fcc699b3f11c15c70ea6b94"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end

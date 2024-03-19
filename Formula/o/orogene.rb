class Orogene < Formula
  desc "`node_modules/` package manager and utility toolkit"
  homepage "https://orogene.dev"
  url "https://github.com/orogene/orogene/archive/refs/tags/v0.3.34.tar.gz"
  sha256 "d4e50c2c3965e62160cf6a15db3734e4a847ca79629599fdd5ce30579aaae9a3"
  license "Apache-2.0"
  head "https://github.com/orogene/orogene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69f7b951549287f79e3521bf54493f3464b51f25eb282d896712cb0f2c5389ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff8c8f2b06868282e41075f6b2ea71223b248f1241717bbda4c49e5a00d3275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03364b2ca8ea736b9190b9f7eac24643cad798ea21194df43e7192cdad845100"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6da3808aab2829307fc1757f7a34e35383494c36ec4b95249c7a11c2ee689e8"
    sha256 cellar: :any_skip_relocation, ventura:        "ed3a3828b602fa96143daa970b774a0fc8c0566a04d9c0b91508cc0e6cd52a0c"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6ab8c186df4e96f348f30e4200ffc1c20cd0835ec7def7f1efe8a34dfc37a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b9488ba3d143c901e3ac00542b7896e83eb09150bebdd31597869831416e4d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oro --version")
    system "#{bin}/oro", "ping"
  end
end

class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.2.2.tar.gz"
  sha256 "adf127e810b862ed8505fcb02b788d6f4498ec9e059a2182b8045b9d1c0fdbd8"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c45e160ec937f37fd2b5b7037391624b110d696144681cd0fc6f0e629f500d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ced433d88a554f34d286f0b2a33baacfd2b4fc2b73306088024b1f0b2e949661"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0edc5ba381001143816fbde44d75005dffac1348bbd03d54e0194d8824dd95a7"
    sha256 cellar: :any_skip_relocation, ventura:        "02c70a9fd18fce4cfa2f4228042d4638a899e90ef169e681fe26e0574e790135"
    sha256 cellar: :any_skip_relocation, monterey:       "b75d13394ab6d33ceecaa1680aa30ca3434360bf4ead41b29a7d972328511a64"
    sha256 cellar: :any_skip_relocation, big_sur:        "c39d08f1e67683bdd2cd5cc6f6b64a5d36419b7bad241936d27eb9f410275100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355dd1a6b8c96be44290e18d8bd812cac977548eb9aebfe873c6e80312d2feb7"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end

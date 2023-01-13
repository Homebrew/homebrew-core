class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.3.0.tar.gz"
  sha256 "7a926a30152d7b746fa58cfc0d97f512c7211d05d6a8a168aee87daf807738ed"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad825ee51f9f576c70abde8c7e8071178d26985f8d57a67a9f253477725a569e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2cc7000f56b329424e5dcc1af7dfe49b510b4167ad70421ed5cf623e48a3194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56253b3ac6722890c22b084e46f38aefacbf8ec8f99911f89c865899307f1345"
    sha256 cellar: :any_skip_relocation, ventura:        "a23f21bc2dab1212bc7c689a289d2cf1819ef2452589a52c9243c5b168c7c5d4"
    sha256 cellar: :any_skip_relocation, monterey:       "08ced7e9997a4cec662157e87dc4bf3c17dee5af7141118e54166fdc9f922e69"
    sha256 cellar: :any_skip_relocation, big_sur:        "2383ea8d7b59228f18111fbfd314b244198c3991835802f67926ae9e09486116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c859142acb158db8e1faafc8ac775fbeb25902f09e32c13d420771186f29d59"
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

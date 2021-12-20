class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v3.1.2.tar.gz"
  sha256 "a5cf45d9dbe3b5803edc8d6d100d1e995df35dda7b0a8b14dbc4e2b0f881da76"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "024bfa3d837322d3a476984de0fbc6c597d7af5515273ad4384cf73ba908ecff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b2922f7031c2ec7a117b61f4da0b0eb011752c374e3f2b26ad371b72f98b544"
    sha256 cellar: :any_skip_relocation, monterey:       "2364c94051c5b2161dde8fe9669de0b8b3b0cfb3d6f6b9001e5880c04584957d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdfee75a46131864ae36c46f4f1464f1071c0e4dd54062ea83ac2cb035cfcfcc"
    sha256 cellar: :any_skip_relocation, catalina:       "628f9a7e7b15693dea3c41be9d1de737e3e759d297a4ea1a8ff5e0c93149a333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29ffacdeb616212ab7899e3dde7a888b421cd46e45bd07e4fca2edd9f2021304"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end

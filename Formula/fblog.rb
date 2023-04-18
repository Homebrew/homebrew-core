class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.3.0.tar.gz"
  sha256 "8c7c74a91fcb53c4d71abc78a3bba9a9fb496481be531a96e526b1bd54ddd41e"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17ab6960bc7602b6173bf0078a51ec426573de55de4bccfa1e29b54c145ba31a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc7563b871037da57ce1ae8842c11727bedca27217ec1b89c3ddaa5889c57985"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e65861ac9804a3a753edd6b2ab58363d7b06bcca53fa7a9267ff65cc832e6230"
    sha256 cellar: :any_skip_relocation, ventura:        "b24f61161ce28af8ea9caad09e36955c26c08530fdc1dcd57f044ddb5bd3c5e0"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e82f373dd9abe5ba520fcb065311ca6592fb5f73c65c16e2318601d14aa911"
    sha256 cellar: :any_skip_relocation, big_sur:        "00b95a8100b27a036db958bd80d014520a6631d6256e6487d284d6cbb39dc309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76b38f34e9346c99782bf3d55f66e5a440ce213f5632b36fb42ddc756433ee1"
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

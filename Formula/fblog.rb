class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.2.0.tar.gz"
  sha256 "de7e7e012301eec9df891a4bbc27088e43a7fdbf8066532fc35e85a38edde5f1"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d04993d81da88cabeec38f9d9df24864e990f29b032683452e93b675377f422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3088629c9a095488e5552344936f0c68c6a9a268b3ff63598a962f93aad14499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e5ad3d4e789259423bb7ae925cef056d2782ba7826d313501f76ab14bc52c54"
    sha256 cellar: :any_skip_relocation, monterey:       "cb8ffaa8fc6904afa6af235422c9f995f5df6d7b5a9e9e2ee86d8736f12d53bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7170652b1db3877a9af8a14c1fbc19f8e391ebfcb3d74a7befcbeef291b99717"
    sha256 cellar: :any_skip_relocation, catalina:       "e4ad5c34818a46e526deb93cdfe167ec1f66a05130cf5271c1e20cd610bde77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee91c7619b1403655f893d7a1fe5c954fe8ac5b5771c7aa4fc386bafc9b6cbc"
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

class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.3.2.tar.gz"
  sha256 "fe759bbbf4ddb2a89d43ac99812f8a3027e2f84fc8f9771db88ac043cc41cbf7"
  license "MIT"
  head "https://github.com/esimov/caire.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c0ce2451e9cc12885d493f1a378ddf847c9110b46c50b78cffb1e3a573b2c62"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad8b6545e150fa79d11c5a3fc47d6babb6ffab6c60534cb2bf061c74c4ba1d51"
    sha256 cellar: :any_skip_relocation, catalina:      "540d8b523e5863f41c8a3bf9aedf0fc5cea694d122a26f60729fa02fd42273ad"
    sha256 cellar: :any_skip_relocation, mojave:        "dd5095e0999f730dc52cd15ad2eac292ad381d96c668c3a92ba3c84dde7c97cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/caire"
  end

  test do
    system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
           "-width=1", "-height=1", "-perc=1"
    assert_predicate testpath/"test_out.png", :exist?
  end
end

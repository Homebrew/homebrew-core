class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "32bd5519581bf0b03f53e5b22721692b99f39ab5b161dc27532c51eafa512ca9"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/mkcert.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9863f54426db9df99173be319b283ec3a08d5dbd320987259676d2ddbb05b9f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f8988b4b5f85474931db021d3b5968576f2be4b151c00d943441196f4186324f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1801aa7c1c50a3f7a11d44cdf9e37a57da7cb7471d0fb495b7df40843b47858e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af89337b73c8d4bb20c0cdfeeaccc17b620d8badf39edfb06a8fb191ec328c36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caadb67940cb551fc16122dc0486cac6a0dc948ccbdf90a5ee75219d4a437fa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9529f010878e1b25e9e65ba68cb541e45878e09c65ad07c9e38090b8f9ed4383"
    sha256 cellar: :any_skip_relocation, sonoma:         "192c46a98732881bdd19acd6da8799ad9a931dbb9b895d22408a8eb8539f822e"
    sha256 cellar: :any_skip_relocation, ventura:        "3bf38fc51225b8042bb2b7274dbf3c1deef6fc0a3db2886c9ab4fe6a8105b851"
    sha256 cellar: :any_skip_relocation, monterey:       "dedd5384a47f6e10702990d15787658cb33ae5c8f45a96869adcc4e0c730b810"
    sha256 cellar: :any_skip_relocation, big_sur:        "26dd205eb0e33469922e8fd3b1828e91b2dfa920c7ffc2cc6f48494fd1c23d07"
    sha256 cellar: :any_skip_relocation, catalina:       "19ed89b5ee9243e2d6880462ac1b0fcec4db64d4b6f2cefe423b248050b6ae15"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "231294ec75a53e64f54d300c71d8b28a4b7c89ba468d426dc751ef242e9876d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f674faa8be61e225ae604b2ffe215927f6ecbc992aac75e769185862820d2881"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
  end

  test do
    ENV["CAROOT"] = testpath
    system bin/"mkcert", "brew.test"
    assert_path_exists testpath/"brew.test.pem"
    assert_path_exists testpath/"brew.test-key.pem"
    output = (testpath/"brew.test.pem").read
    assert_match "-----BEGIN CERTIFICATE-----", output
    output = (testpath/"brew.test-key.pem").read
    assert_match "-----BEGIN PRIVATE KEY-----", output
  end
end

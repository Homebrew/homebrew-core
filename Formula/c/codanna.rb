class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.12.tar.gz"
  sha256 "e391c8ed5a79fe3a0237e60916562100c1869f026e7479f1ea7c4e78cb28cdb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "baee8b9956d75d3a65f0241e9befc41023f01e0bfba466a127e9bb169a247798"
    sha256 cellar: :any,                 arm64_sequoia: "996b3fa11d89595f1dcf8f40765698a01818f436a88f2ac67d9ff4ad8994363c"
    sha256 cellar: :any,                 arm64_sonoma:  "b869d935b8c28a6f593c259f2a94155ecc029f96a159cfeb2b8a2315b79cb37d"
    sha256 cellar: :any,                 sonoma:        "db4e09cd8294697d1f8c4d8e38cd4d406ed903e640296eb99e60c52b16bacb2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c8f84ea84a2e17d546382a1f96d11a755797c4374e2e62a93c1bfa57aecf52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ac7c0c2a760e3432df078ddb0349466b8ebb85f0a1cc1bfa6059cb85a26f9c3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end

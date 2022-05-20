class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.15.1",
      revision: "5d14f73963cfc0c226e8b06c0f5c3404d2ec2e77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e1f3f5a121da38eba0d123472b4a9409e74323b6b6b816582ea227182fc0ffc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07174f536e39b42396a75fda7422b9588f55d95795ba78efbf7406d60cf7d0c6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d84b7fa8d5d68de16a45dfa95f8d0924403457874815d79531d200e3b75b428"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd32668dbb388a6f877e70218754982a101f165c6b1e7c5772d9ba44d581927b"
    sha256 cellar: :any_skip_relocation, catalina:       "f47a1458fcf3225657bfac99adead69fa765ee10b2058fe038085d81c6f1e93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "917decf5660f645a7ec7feaac8959f8d1cf3ca6a28cf085fdc6c74544274f83a"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end

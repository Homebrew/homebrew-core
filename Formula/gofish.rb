class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.14.0",
      revision: "313faece77b4fe5645def5fe2da996dd7c20efd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3afbc92954f09ba10ee34967de7884b82dd9bf6d539eb9051847423501149161"
    sha256 cellar: :any_skip_relocation, big_sur:       "6192b146fa5b8bd4f9383b5b342cb432e465395ad5e786cca0ad0f5f97311a9e"
    sha256 cellar: :any_skip_relocation, catalina:      "db76c4f80f2bcc9de811fb78d24ef3352a18072720edd3ba8fd0c985fdc1a41a"
    sha256 cellar: :any_skip_relocation, mojave:        "c2571af53fe2460268ad217cfb20fdcf187d29a5106393949ca22b64cfc69c49"
    sha256 cellar: :any_skip_relocation, high_sierra:   "97f68fea6cc4d9e3f7fe5cb6256f7fe7d3558df6067106d17adc274728464635"
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

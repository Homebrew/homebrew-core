class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "1ba5a700d7785e8ac399daca4fa7367797e48071909d72a0e9f12c06b9e62140"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "292ce7fe9921d8f34ec4dbb2993d84324a82c985a60c1309516f3b38f643ce31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b86897730eb5df03386b0c539e92240867873897f941ae60b20e79641489ec3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a99b8ca4065742e0c5e7bf4a55ade2343cc8d38add5b47d27cc411f1bd0b69e"
    sha256 cellar: :any_skip_relocation, monterey:       "89bb5c5c525218aa7012cdf30e39e3bf172c8c3c875cd304332e1d08e763397d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cc16bc15c83be7275e7027814b6db79aaa1500d3ba5cb7612c0b1fb41516af0"
    sha256 cellar: :any_skip_relocation, catalina:       "74706e60d06d0d195939939d13f3b287e4758cb49284c167e842b3fe8867ffce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e45ff09641d7862bac10c34cb95a345a2080e80b7a7e8bb8c578a24873d4f3e"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      /Initialized status surfacer/.match?(line)
    end
  end
end

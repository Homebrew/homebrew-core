class Clac < Formula
  desc "Command-line, stack-based calculator with postfix notation"
  homepage "https://github.com/soveran/clac"
  url "https://github.com/soveran/clac/archive/refs/tags/0.3.4.tar.gz"
  sha256 "3ee19329cc2e2d3a4d70eab9aa9e89f0e6f07becaa89e9156e5eb2cf94dc568a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d6980c6518c868fc7755967f1fb4c9e1801f01552cc273d88ef196c190f09bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4567b96d52b717dcd08a39d9540400ec62706fef56604355c19d97be23fa263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7c0e290434255b7da84b9f7338d97fdfebfd94f1d644354630e7f4da4db61dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18c5e0e27145bcbf03d697cad009393e0cc358a5c68d02a18d10f0d97934b9c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "99f0efd095f5a0ae1da2ed0251a1753cce042069a49a299c29b17c8edfc5c558"
    sha256 cellar: :any_skip_relocation, ventura:       "f4b1d600a712d9d93e03393fc16bc762f6aeb33edd9840fb0df0d9d79aca8e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f2128ed4ab7836c72efdb33e23fc6376a383e9f0bdc057490c2f7cf9b67339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "388b23eacd1cd72f8101ce8f2858d9ad232de844cdcf7f3a9948f98e5d56cea2"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "7", shell_output("#{bin}/clac '3 4 +'").strip
  end
end

class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://github.com/boostorg/bcp"
  url "https://github.com/boostorg/boost/releases/download/boost-1.90.0/boost-1.90.0-b2-nodocs.tar.xz"
  sha256 "9e6bee9ab529fb2b0733049692d57d10a72202af085e553539a05b4204211a6f"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a11c0cd500e8441eb556e7ad81baed855e3d0b93d4d7327ff7efb3a5e0670630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e0fbc2ae2085838d8153947786b2f467bcc21e13741aed64ac30d2bf6ceb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c73ad83f402220431fe2a1a92afedea606bf1783838d757cb01cae64f84a34"
    sha256 cellar: :any_skip_relocation, sonoma:        "34b5df6c619143ac0155e6f350d5ea0272a07d79954a1c132a4e9a848e0b2172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca7095df4f8945dc06a9b23a4402e27ea7acf7ce408693e9f79008751fb527b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cddec666359924f6651452e275ff45901538cef7155dda368ea28d4eccbdc54"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end

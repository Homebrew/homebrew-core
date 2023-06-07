class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.4.tar.gz"
  sha256 "f58d834876ebcc8e5f21e94e0db42b173d2bea600642cbbbb6dab16a6b5d7537"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4a216f56df26aff08e84ea6b81ec7761a79ccfd8ab140f0dd6fe62f389a183d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "152c13927b088e6f0ad1733e4540a6197a32dab7d674659cb966a95bda94316f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc115c42134e98b2b9fa537715a9af7b44bfc22de71cad41df6c3ae104be80bd"
    sha256 cellar: :any_skip_relocation, ventura:        "7f27b7724b2f1f19d4bffd30c99fef77243349b76e519a2b92bda3d640786e51"
    sha256 cellar: :any_skip_relocation, monterey:       "3026cc94e32968aa407186fbb3406f844228e82fb5c84d20b6a58753c1d943f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "20defb82713908472254c03c45b25e4eb224fd703e1bed428809d930cfe5c138"
    sha256 cellar: :any_skip_relocation, catalina:       "f1c5fdc878cf1eb50c934e1741ef86ddc70036bc389b01dd179a0ca339ce79d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6adec880587fce1266c753dc41af3f237eddf9709d225b9dc36184d9474f8a1"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end

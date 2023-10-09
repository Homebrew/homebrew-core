class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c7808b8b4a6e801a484878a7cd455635414bd8d30e825ef9dedca3a1ec61b32d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6e2b282d00f2be3ceccf068a47786a239520fc8e1a77d9e8662755c27245067"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b50e16eeb1c95acabbe7143a31f2e9ebfe9825aa1532d8e5b5eb70286cffe439"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd8c8c24d9dcbeb3531ef2da4c7e632de0aa62ae29bce92c0e803f079c1116c"
    sha256 cellar: :any_skip_relocation, sonoma:         "622ca571046b019fed842239db1abccaa04bda5b5e00fc9738d7e38f9474fae0"
    sha256 cellar: :any_skip_relocation, ventura:        "9c81ee25b1bdcd622cc1f263c7c1a256279fcf23f688538b5feff4788b02e1d8"
    sha256 cellar: :any_skip_relocation, monterey:       "9f7123be10645e20b4407e4702f799d9db9417dde0f268bd202b1af0d76440e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb85f12bf5baae71c04af65ad94eccde96d18af12c01603268761533e3036864"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end

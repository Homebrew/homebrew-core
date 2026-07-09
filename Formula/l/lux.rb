class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "69d4fe58c588cc6957b8682795210cd8154170ac51af83520c6b1334901c6d3d"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3d1177667581ce7d8f5dab853e3e6c88d2eba6fc3855b5821a29e3a525880585"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "098c398f3aab12f2479004b768757b98ec66c4473c392345b0bc5b5b37c690b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec6c1ee606e93f2a6d69f052926d6646ea9b3d55b818392ce48b60bcbd2b5464"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7efda3117e78deb37e8131758ebaac2ad7956ee9f874703baa273416d9854763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca4e5eb68eb6190a9121273861c7e54224ad8845854b3e28a57d775fc5ee5f70"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d09d3f7176d099619dd6f5578c65af77e9e74a0604cc248f879959c204136a8"
    sha256 cellar: :any_skip_relocation, ventura:        "06dac67a49a44e204415365d22dec09363c2ad4247fc8e787791960ad25da706"
    sha256 cellar: :any_skip_relocation, monterey:       "3293e792b745857668443f88fdbd7cbb50f599e2c5720da0419a0765e897e049"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0e97fcc580fd60597f9373e72a185c7863f2ea3cd0dbb3d46f3f85d9c3d81de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52fd63821ac62400e3c1a1ade593edd328d4f6136d44a21309fd9d188120c115"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/iawia002/lux/app.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"lux", "-i", "https://upload.wikimedia.org/wikipedia/commons/c/c2/GitHub_Invertocat_Logo.svg"
  end
end

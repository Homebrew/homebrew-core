class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.4.tar.gz"
  sha256 "cca8ff43968ef97d0d623619c246f7425cd87956b254793575141402c606e977"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80e5c8037e79c47128f51352c889c2607b8da63c4b1bc531b4764f4fdb15a5de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4e20876054c3674ad39c0d4793e4131519ca5b5d6e478b69d41d5e11d22168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce332a5be84c41c60161efbc7d2291da07ff4e95dd5816ddf017a0a40cc99f6d"
    sha256 cellar: :any_skip_relocation, ventura:        "27845477025cbc79f66c07e02bb34bd1e7e5c89d3e39a54459991e3ac5298be2"
    sha256 cellar: :any_skip_relocation, monterey:       "6956340289199fc1a74143e5407b7b09d761d6cdba966aee23b65cf6be3614e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f0aef8cc04b350231d09792d6bb737121788f39d01ab77279552565b10fb3d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76a79b257d2cd4e1027552ed5eb42b3e5a4727cad4173eeef020209758cbea09"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end

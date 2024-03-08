class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "a01759599c72bddded99c19e6a49fa97f0a142ec5b28d083ca652e2c8f5096ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c86705b703f013b95bd88cd1b2a0620a6fe783ed55293431e51c130e732d47f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9573cdeaa4a344f2130b6ac3426ff27b48b432288dcab958916667a9c3f42ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc2cdbd1fb953d5867466c3a28e91d983a9dc831a673c18d800a88520ea50fa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7bcf9433d8ebdc6cb79b091e26b098ed053633fccb1763dd58adeb909c03711"
    sha256 cellar: :any_skip_relocation, ventura:        "19fcba84fcd442e3a5bded570a9595e81b839c8730bd9b978bcb8f6d946db769"
    sha256 cellar: :any_skip_relocation, monterey:       "3531e2fe9597abfcde6c235784b3a01f8ca1bb414391749605ff569962149ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b6fadade8f74085e09355bf44a590b5419244bebf5cb1c1790140d4e059ff2"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end

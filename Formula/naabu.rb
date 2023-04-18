class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.5.tar.gz"
  sha256 "04c9806123ec31da5329fedf1af562aee42a5d666465ef3856b7c78a43703075"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e72c310dc9a611a741c644a9f81c793102c787a5b13a4f4c1fa59e786429380"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e72ebdd6a050606e21e22cf21d9f554a9dfe587abc56af83d2a0df4fcb1745f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4382b52c74096917898b6dab5b445368b016b6fe8b43b612cf7f5324636dcf4e"
    sha256 cellar: :any_skip_relocation, ventura:        "11b307ea15788d9b1f030c82dc7ba8b9f6ffc2f55aae7a844ced0b2ceb10e073"
    sha256 cellar: :any_skip_relocation, monterey:       "0db29e1d2eb312c4a3c0c98401cc6db68d1aa31df2c5fd31f33376aaec6e5a56"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad3e42dca286e6e9415eb8a7578375dc799ac77834640f983d65e359ba50f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2012a1f9283915cda8eb6ca871ad2d48186fc676e57b5afc6e61a8ab58dc0dde"
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

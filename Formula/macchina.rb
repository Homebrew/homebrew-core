class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.3.tar.gz"
  sha256 "eb7bf657813a8b1cd6da2751744b4ec38bf4ebd4c11bf9deece84dd6ba8d97ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02e348e0c8afcd6ba5a1b41853915928fc20541e9e5220cb0cd4d4739e510476"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0da77269184752c41ede9b165eaf4a43f1f5a53d2f5e6c6d5cce29e201005361"
    sha256 cellar: :any_skip_relocation, monterey:       "558a5a305c64ec2557ae2585f0b8c22a524b1daded14df74e87bab7375d269e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9148903a5b7e477efbc8f6efe26da0977e8336dad59f4343c2ea86cc0063262a"
    sha256 cellar: :any_skip_relocation, catalina:       "8afc5042718e5d6c33aad6d751411e9e16998eff4de5b0404e43823226c8ce13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d875e84502adad94e5e8ff23a5070be06385c9fc3cef96b3f713c0f0fd75bbb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end

class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.3.1.tar.gz"
  sha256 "45e8ed1e3131d4e0bacad2e1f2b4c2780b6db5a2ffaa4b8635cb2aee80bc2920"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c14e4132238b567dcefa076e8008748d1f8b49e76f787fa2b677c5dfafdb69c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b31bb9f7e07f5c1bb8a3b961c2542a322991beff406362dabacd2c96265896c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a69b599da29f9f1a39435c03e9f874b856ed059205d9880369b68abee25ca6e"
    sha256 cellar: :any_skip_relocation, ventura:        "7edb742b84fe15e9408f5a5e9e3f04c6496f7485beb2259a62992aa83f4b89a7"
    sha256 cellar: :any_skip_relocation, monterey:       "77f6b1e152c6e1210b281e6f22c43f1805753fb5c4aef68c734b0a3035300c1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee9c663b8f11c7498ead2f44697dfa82db829bf44be26cfe9ea2bce3c3f1b841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90aeb989295f313f9ef0c5881230816939307c1aa9e400cabb632f9660496c2d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end

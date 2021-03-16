class Macchina < Formula
  desc "Basic system information fetcher, with a focus on performance and minimalism"
  homepage "https://github.com/grtcdr/macchina"
  url "https://github.com/grtcdr/macchina/archive/v0.6.0.tar.gz"
  sha256 "bf6eaaca560fd2e7f04594abc6fc4615e6d3867a74816a26146f0244266cdffe"
  license "MIT"

  depends_on "rust" => :build

  def install
    cd "macchina" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    system "macchina", "-b", "-p"
  end
end

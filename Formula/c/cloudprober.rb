class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "2222863d15048b507b7f2ecbe45986d160654ce30034061423e640244b449c2e"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98620d60e997c5fdc947b08cf9aa1e23c88f5d2726a1f9ea1e9d06465c072adc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f07c0d4803e1e4379f27055e9cc82d8286582a21817d9ee046601bbccb75f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c1f1057ce7ddcb7f916477856a189a6a879e338f8a76be5a2b8cefd353acfc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7a7052819d756b70e76a1df825d9a03ad2e5e65a703ef4581d4009b2c7b3c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a427508ead40bca059414dc219e506fa95dbca3939409f3e7a66b0bde200838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e091ee05565985fc772cd2387f51bcae33d1c8f758eef5c56378fdb46e023cf"
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

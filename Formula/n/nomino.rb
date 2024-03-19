class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.3.3.tar.gz"
  sha256 "eca89f615f5891df227dab6162200a12b17e3a6517bd888c9b050a714ef8708b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dafcda84a28362f50d969606895d6760bb5d2380d9fa0f787232a0499bf0e686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b37b09479bfaa55b021d0c1242532b2249acf822aab0f9583cf96fe5df3bc5e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c55f03e2f3342e7ba7dcd159fda91c5f540109bdfc0e079c69dd0c3c805ee9e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "da020725f227ad9cf4f5f8dca0c64495f33c2a63fab162ba2a83dd7b7bbabce9"
    sha256 cellar: :any_skip_relocation, ventura:        "a4bc37c42bef56392adef4873880ede46447212e2252c2803ed70cf893740ed5"
    sha256 cellar: :any_skip_relocation, monterey:       "7c79d5312984f4292b1a82ebd50236cb16ea1935b5ce8f7d6ae2fc6170d282d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eab0305fdb7b2e9da3e180328dcb90188e4bb4bbd77148ffd5363866dcc6c21"
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

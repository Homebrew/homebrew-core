class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.6.1.tar.gz"
  sha256 "8d6a664b7b557d7d3e7f057eada63e153a26af68bedbbce45523164641d497c0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b95d0c88287d5238b0a97ab6798ead5edba94048077558a4725efee43b32fb51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c6d478132735d240053a7e633e4c95427aecd54a056ac286da8442a40021c55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4471731584112265bb13937d2dd8fbb861100d74d9fde989ee81fbc1569504b"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a299ee5a482716c18c115614d95a176790afe2fe003d1f26b81b3efda2a267"
    sha256 cellar: :any_skip_relocation, ventura:       "9c6ce75e5565cdcac444af92b510379cf5b7f7723f71eb4ac96a01c74b8fad22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c8aaea80c57609902d641da9f07163cf43f80a70c4c3a3e2b2fd320e7be652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbff625abb4d8f07a1e052a6e3149c0f7d58ea5c4d66939fa42e82facffec17c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_path_exists testpath/"Homebrew-#{n}.txt"
    end
  end
end

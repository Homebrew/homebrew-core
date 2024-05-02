class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.3.4.tar.gz"
  sha256 "a4a75307c29ea5f729fbce8836db6302b9b298fcd9b23cf71d626878ce1dfad7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a40465524c2905a0f5c2f4063731ad6d227a176829ec49864c1813d4184fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89a841ef7719b07d46f1f5b7df017fe69f1865c23a93c3729fa9d5726bcab21b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7c27895f4c782b6c3220e3424e8006ecf9cfad7b8ac57b1a7bbd30b49f09781"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a0b00a299c9c541772e00a1f551d42ef79ce7f31e437f9b086188b0479bab42"
    sha256 cellar: :any_skip_relocation, ventura:        "a4b15bb529ed1e3f981864f7a566ef95037c2a73f23c950ccb59bf8c604f225f"
    sha256 cellar: :any_skip_relocation, monterey:       "9a89b365b9e063af353eabeab66ca16ad888475063747a8ebf781b8229fa0527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d6241e0dee8299cae62b2f11e24b8247bf76088d2407c73d1ec43c0b79ace01"
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

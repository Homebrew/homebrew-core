class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.3.2.tar.gz"
  sha256 "2923903b75a6a892e39345b7ed61708719912dc8c7bda28be3f55b1615fd102c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d895cd974f67c9d202190567199b369f655e998b7a8fbc4e8d0f2ebf6e42df5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0fe46b75bcaa00b2a061d24ccfcf391817949c03e9406265c82974b4d77d157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "298644c6d44e434928d063cb1e429b0eb734e7ee74d34c59d0b7649665aa3157"
    sha256 cellar: :any_skip_relocation, ventura:        "7e89a79d75476eed1c9540e83fdbb99fbf61a5f2bec130a57c359118b981a67f"
    sha256 cellar: :any_skip_relocation, monterey:       "0f589b3a7bb8a9cb0a6c5b8bc59264985bcb5a5e04d29e1b3ca0500436b42012"
    sha256 cellar: :any_skip_relocation, big_sur:        "99a0689bde495763685732819d49859ca90002f9575b3b147bcbc96f062e8ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f0c2a3b9785138a58c99584d3b97e21a5910e2f6894ba588fc0c22b2b110ab"
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

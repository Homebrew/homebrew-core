class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.2.2.tar.gz"
  sha256 "d9c925a09e509c20f10aba6b8130412f6f6cf91cfa398933e432da2a6626b83e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3242084099a30e161727977b3dcb5095758d84f3a75ec4d3bb782edbda04c1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad0076d622c8490155076f8aa47074c3391965ead1ca81633284c1e858fa424"
    sha256 cellar: :any_skip_relocation, monterey:       "e59071ecb110e1d95855ebd6ac62a5910b8ffe187768c862a5428052769e3ff5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecc1a559be5387e04e708f38427dfd9b1b38f52772c70e1aae349cc67bb8e02"
    sha256 cellar: :any_skip_relocation, catalina:       "621c85741ac046026ebd63732f910416ca14e39eb6ae6e06fa67a29fbf0e5cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80c9cabfc011c3f566b9ae4c982eade843f42d08dd3c16611aa08025ae0e84a"
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

class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.1.0.tar.gz"
  sha256 "8c41276a2e27eca7222159c709e4e8b4e7c9e21c5cc029a0058d966865362548"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d616576d0b9e05ab04863ba9dc637cc2f1a206984d57511a2ae6805c44d9bb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9bc4251a64b1dc2b091fd414aae0d6b8fddeedd1d6c1c81136aa13ba1b3466e"
    sha256 cellar: :any_skip_relocation, monterey:       "987eb401fead9a9def2a2339efee5c63f64f1105e8c68adad49526d835736c16"
    sha256 cellar: :any_skip_relocation, big_sur:        "51056d253a62760ef972f909d1425be9c63b2ddb10d337a0f3d8ad86aec97dca"
    sha256 cellar: :any_skip_relocation, catalina:       "1656706972c24f6b507d14c129321fba583b90903b19731230e854d483163773"
    sha256 cellar: :any_skip_relocation, mojave:         "5e23bb5c2901ed77aa0cb0b114916440e3369bf612a13d02f036aee6164982ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d65d7fe2ad0420b240271ca54c2e2ac2e3d8f5a63d249ae653aa5ef22acd2ec9"
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

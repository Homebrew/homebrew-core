class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.6.4.tar.gz"
  sha256 "e83d9a62163f9faaff4c6650284de3dbe92e546ac09e3717c0bb9cde8352d005"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5f816f0bc309590106511a3913e3864719fecabb585ce02fa7628d32de348c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91c62681b3095ba073e2347bb73a7ae656becbfcebe653d17a0272adf6c137f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844fd63f5668aa2fadd5d5eb1d60e927bdc4b2a6147844116a2c58db614ff0fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e3938593b0e08bdef22fb21806acde14e003a385a2bcbee17f9eda7a99c727e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc995512aaa7e49fa27d1d758e423aa8f89172382291ffd73fd1a0e4def4c04b"
    sha256 cellar: :any_skip_relocation, ventura:       "159c8a020cbf814028a0ccb704dde386b9ca9894ee174fbe87882d57e5198a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31653756284a49363a9d7ea3d169f8e7cba14ba660e06b8b86647f792905f189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f688e778ba20b4394687dd2cc845df0aacdce99a06ea2fb200bf0c0b8aac44c6"
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

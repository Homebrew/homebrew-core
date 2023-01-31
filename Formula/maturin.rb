class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.12.tar.gz"
  sha256 "b1b665ffdfe6fa7f6f7e3ee2b7c3927567dbebea704141ab30dae3a88aba82be"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d4ad745110b0713ed5d00a824081e70d024d124965e804107393a76df628983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04d304ca82b75ed0d1a7ecbe18e1bcceba97bab9fcbd0cdae2802f0c90a90f14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17a1daff11795ebc6b2795b96fcadac33f69fcfb9176eb8d6d3877769f71222a"
    sha256 cellar: :any_skip_relocation, ventura:        "ef21eb26e72bd3fec09338c4607598dda1417765b10af530f16c51e22198e3c4"
    sha256 cellar: :any_skip_relocation, monterey:       "a374f0403e06791ba2ca830208f8acc9f3c6b283b656d8391083af6289847fb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd4f0317d0c5b57fa723f70442cba5b9025020cfce143bab3f13b383e0dfcac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b702bdc2679fba4735c0070aeb4cd4379685493f3d3b3ee22319d06150534b6"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
